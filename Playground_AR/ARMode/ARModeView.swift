//
//  ARModeView.swift
//  AR-Basic
//
//  Created by Settawat Buddhakanchana on 28/12/2566 BE.
//

import SwiftUI
import RealityKit
import FocusEntity

struct ARModeView : View {
    @State private var modelPlacement: Bool = false
    var productTitle: String
    var model3DURL: URL
    
    var body: some View {
        ZStack{
            ARViewContainer(modelPlacement: self.$modelPlacement, productTitle: productTitle, model3DURL: model3DURL).ignoresSafeArea()
            VStack {
                ModelNameView(model: productTitle)
                Spacer()
                CameraUIView(modelPlacement: self.$modelPlacement)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelPlacement: Bool
    var productTitle: String
    var model3DURL: URL

    func makeUIView(context: Context) -> ARView {
        let arView = FocusARView(frame: .zero)
        ARVariables.arView = arView
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if self.modelPlacement {
            // remove AR object before place
            let modelAnchors = uiView.scene.anchors.filter { anchor in
                return anchor.children.contains { $0 is ModelEntity }
            }
            modelAnchors.forEach { anchor in
                uiView.scene.removeAnchor(anchor)
            }
            loadModelIfNeeded(into: uiView)
        }
    }
    
    private func loadModelIfNeeded(into uiView: ARView) {
        let request = URLRequest(url: model3DURL)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading model:", error ?? "Unknown error")
                return
            }
            
            do {
                let tempURL = try saveModelDataToTemporaryFile(data)
                
                DispatchQueue.main.async {
                    try? loadModel(from: tempURL, into: uiView)
                    print("loadModel successfully")
                }
            } catch {
                print("Error processing model data:", error)
            }
        }
        task.resume()
    }

    private func saveModelDataToTemporaryFile(_ data: Data) throws -> URL {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(productTitle).appendingPathExtension("usdz")
        try data.write(to: tempURL)
        return tempURL
    }

    public func loadModel(from url: URL, into uiView: ARView) throws {
        let modelEntity = try ModelEntity.loadModel(contentsOf: url)
        // comment because simmulate build error
//        let anchorEntity = AnchorEntity(plane: .horizontal)
//        anchorEntity.addChild(modelEntity)
//        uiView.scene.addAnchor(anchorEntity)
        
        modelEntity.generateCollisionShapes(recursive: true)
        uiView.installGestures([.rotation], for: modelEntity)
        
        print("Model Placed")
        
        DispatchQueue.main.async {
            self.modelPlacement = false
        }
    }
}

struct ModelNameView: View {
    var model: String
    var body: some View {
        VStack (alignment: .leading) {
            Text(self.model.prefix(14))
                .font(.custom(customFontBold, size: 26))
                .lineLimit(1)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: 70)
                .background(Color.black.opacity(0.8))
                .cornerRadius(50)
                .offset(y: 25)
            Spacer()
        }
        .frame(maxWidth: 300, maxHeight: .infinity)
        .padding(20)
    }
}

struct ARVariables {
    static var arView: ARView?
}

struct CameraUIView: View {
    @Binding var modelPlacement: Bool

    var body: some View {
        HStack {
            // Camera Button
            Button(action: {
                if let arView = ARVariables.arView {
                    arView.snapshot(saveToHDR: false) { (image) in
                        //Compress the image
                        if let imageData = image?.pngData() {
                            let compressedImage = UIImage(data: imageData)
                            // Save to Photos
                            if let compressedImage = compressedImage {
                                UIImageWriteToSavedPhotosAlbum(compressedImage, nil,nil,nil)
                            }
                        }
                    }
                }
                print("Press Camera Shot")
            }) {
                Image(systemName: "camera")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            // Place Button
            Button(action: {
                print("Place Button")
                modelPlacement.toggle()
            }) {
                
                Image(systemName: "square.stack.3d.up")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.3))
    }
}

struct ARModeView_Previews: PreviewProvider {
    static var previews: some View {
        ARModeView(productTitle: "Sample Product", model3DURL: URL(string: "sample")!)
    }
}
