//
//  ARModeView.swift
//  AR-Basic
//
//  Created by Settawat Buddhakanchana on 28/12/2566 BE.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct ARModeView : View {
    // State for place model
    @State private var modelPlacement: Bool?
    
    // Product title for display AR Object
    var productTitle: String
    
    // Name of Product for display AR Object
    var model_list: [String] = ["toy", "pokemon", "robot", "biplane"]
    
    var model: String? {
        return model_list.randomElement()
    }
    
    //    var model: String = "toy"
    
    var body: some View {
        ZStack{
            ARViewContainer(modelPlacement: self.$modelPlacement, productTitle: productTitle).ignoresSafeArea()
            VStack {
                ModelNameView(model: productTitle) // Use productTitle here
                Spacer()
                CameraUIView(modelPlacement: self.$modelPlacement)
            }
        }
        .onAppear {
            self.modelPlacement = false // Initialize to false
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelPlacement: Bool?
    var arView: ARView?
    var productTitle: String
//    var model: String = "toy"
    var model_list: [String] = ["toy", "pokemon", "robot", "biplane"]
    
    var model: String {
        return model_list.randomElement() ?? "pokemon"
    }
    
    
    func makeUIView(context: Context) -> ARView {
        let arView = FocusARView(frame: .zero)
        ARVariables.arView = arView
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
        // if push place button
        if (self.modelPlacement == true) {
            
            // condition for remove AR object before place
            let modelAnchors = uiView.scene.anchors.filter { anchor in
                return anchor.children.contains { $0 is ModelEntity }
            }
            modelAnchors.forEach { anchor in
                uiView.scene.removeAnchor(anchor)
            }
            
            // model name + type of files
            let filename: String = model + ".usdz"
            // load model to Model Entity
            let modelEntity = try! ModelEntity.loadModel(named: filename)
            
            // Add Anchor Entity
            let anchorEntity = AnchorEntity(plane: .any) // Preview Fail because this is not available on the Simulator
            anchorEntity.addChild(modelEntity)
            
            // Place Model to scene
            uiView.scene.addAnchor(anchorEntity)
            
            // Generate collision shape
            modelEntity.generateCollisionShapes(recursive: true)
            
            // Install gestures for rotation
            uiView.installGestures([.rotation], for: modelEntity)
            print("Model Placed")
        }
        
        DispatchQueue.main.async {
            self.modelPlacement = nil
        }
    }
}

struct ModelNameView: View {
    var model: String
    var body: some View {
        VStack (alignment: .leading) {
            //            Text(self.model)
            Text(self.model.prefix(14))
                .font(.system(size: 26))
                .lineLimit(1)
                .foregroundStyle(Color.white)
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
    static var arView: ARView!
}

struct CameraUIView: View {
    @Binding var modelPlacement: Bool?
    static var arView: ARView!
    var body: some View {
        HStack {
            // Camera Button
            Button(action: {
                ARVariables.arView.snapshot(saveToHDR: false) { (image) in
                    //Compress the image
                    let compressedImage = UIImage(data: (image?.pngData())!)
                    // Save to Photos
                    UIImageWriteToSavedPhotosAlbum(compressedImage!, nil,nil,nil)
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
                print("Press Place Button")
                // place action
                placeModel()
                
            }) {
                Image(systemName: "checkmark")
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
    
    func placeModel() {
        modelPlacement = true
    }
}

struct ARModeView_Previews: PreviewProvider {
    static var previews: some View {
        ARModeView(productTitle: "Sample Product")
    }
}
