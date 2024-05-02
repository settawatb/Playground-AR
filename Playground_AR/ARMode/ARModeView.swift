//
//  ARModeView.swift
//  AR-Basic
//
//  Created by Settawat Buddhakanchana on 28/12/2566 BE.
//

import SwiftUI
import RealityKit
import FocusEntity
import AVFoundation
import PopupView

struct ARModeView: View {
    @Binding var modelPlacement: Bool
    @Binding var isLoading: Bool
    @State var showingPopup = false
    @State var showingPopup2 = false
    var productTitle: String
    var model3DURL: URL
    @State private var showFlash = false // State for flash effect

    var body: some View {
        ZStack {
            ARViewContainer(
                modelPlacement: $modelPlacement,
                productTitle: productTitle,
                model3DURL: model3DURL
            ).ignoresSafeArea()

            VStack {
                ModelNameView(model: productTitle)
                Spacer()
                CameraUIView(
                    modelPlacement: $modelPlacement,
                    showFlash: $showFlash, // Pass showFlash as a binding
                    showingPopup: $showingPopup,
                    showingPopup2: $showingPopup2
                )
            }
            // Flash effect
            if showFlash {
                            Color.black.opacity(0.5)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.7), value: showFlash)
                                .onAppear {
                                    // Hide flash after 0.5 seconds
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        showFlash = false
                                    }
                                }
            }
        }.popup(isPresented: $showingPopup) {
            
            VStack(spacing:0){
                ProgressView()
                Text("Image saved to Photos!")
                    .font(.custom(customFontBold, size: 15))
                    .foregroundStyle(.white)
                    .frame(width: 200, height: 30)
                    .padding(10)
                    .background(PurPle)
                    .cornerRadius(10)
            }
//            .background(.white)
            .padding(.horizontal)
        } customize: {
            $0
                .autohideIn(1.5)
                .type(.floater())
                .position(.top)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.5))
        }
        .popup(isPresented: $showingPopup2) {
        
        VStack(spacing:0){
            Text("Model placed!")
                .font(.custom(customFontBold, size: 15))
                .foregroundStyle(.white)
                .frame(width: 200, height: 30)
                .padding(10)
                .background(PurPle)
                .cornerRadius(10)
        }
//            .background(.white)
        .padding(.horizontal)
    } customize: {
        $0
            .autohideIn(1.5)
            .type(.floater())
            .position(.top)
            .animation(.spring())
            .closeOnTapOutside(true)
            .backgroundColor(.black.opacity(0.5))
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
        if modelPlacement {
            removeExistingModelEntities(from: uiView)
            loadModelIfNeeded(into: uiView)
        }
    }

    private func removeExistingModelEntities(from uiView: ARView) {
        let modelAnchors = uiView.scene.anchors.filter { anchor in
            anchor.children.contains { $0 is ModelEntity }
        }
        modelAnchors.forEach { anchor in
            uiView.scene.removeAnchor(anchor)
        }
    }

    private func loadModelIfNeeded(into uiView: ARView) {
        let request = URLRequest(url: model3DURL)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading model:", error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let tempURL = try saveModelDataToTemporaryFile(data)

                DispatchQueue.main.async {
                    do {
                        try loadModel(from: tempURL, into: uiView)
                        print("Model loaded and placed successfully")
                    } catch {
                        print("Error loading model:", error.localizedDescription)
                    }
                }
            } catch {
                print("Error processing model data:", error.localizedDescription)
            }
        }
        task.resume()
    }

    private func saveModelDataToTemporaryFile(_ data: Data) throws -> URL {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(productTitle).appendingPathExtension("usdz")
        try data.write(to: tempURL)
        print("Model data saved to \(tempURL)")
        return tempURL
    }

    private func loadModel(from url: URL, into uiView: ARView) throws {
        let modelEntity = try ModelEntity.loadModel(contentsOf: url)

        // Place the model in the AR view
        let anchorEntity = AnchorEntity(plane: .horizontal)
        anchorEntity.addChild(modelEntity)
        uiView.scene.addAnchor(anchorEntity)

        modelEntity.generateCollisionShapes(recursive: true)
        uiView.installGestures([.rotation], for: modelEntity)

        print("Model Placed")
        DispatchQueue.main.async {
            modelPlacement = false
        }
    }
}

struct ModelNameView: View {
    var model: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(model.prefix(14))
                .font(.custom(customFontBold, size: 26))
                .lineLimit(1)
                .foregroundColor(.white)
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

struct CameraUIView: View {
    @Binding var modelPlacement: Bool
    @Binding var showFlash: Bool // Binding for flash effect
    @Binding var showingPopup: Bool
    @Binding var showingPopup2: Bool
    @State private var shutterSoundPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    // Camera button action
                    print("Press Camera Shot")
                    if let arView = ARVariables.arView {
                        arView.snapshot(saveToHDR: false) { image in
                            if let imageData = image?.pngData(),
                               let compressedImage = UIImage(data: imageData) {
                                UIImageWriteToSavedPhotosAlbum(compressedImage, nil, nil, nil)
                                showingPopup = true
                                playShutterSound()
                                showFlashEffect() // Trigger the flash effect
                            }
                        }
                    }
                }) {
                    Image(systemName: "camera")
                        .foregroundColor(PurPle)
                        .frame(width: 60, height: 60)
                        .font(.title)
                        .background(Color.white.opacity(0.75))
                        .cornerRadius(30)
                        .padding(20)
                }

                Button(action: {
                    print("Place Button")
                    modelPlacement.toggle()
                    showingPopup2 = true
                }) {
                    Image(systemName: "square.stack.3d.up")
                        .foregroundColor(PurPle)
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

    // Function to play the shutter sound
    private func playShutterSound() {
        guard let soundURL = Bundle.main.url(forResource: "shutter_sound", withExtension: "mp3") else {
            print("Shutter sound file not found.")
            return
        }
        
        do {
            shutterSoundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            shutterSoundPlayer?.play()
        } catch {
            print("Error playing shutter sound:", error)
        }
    }

    // Function to trigger the flash effect
    private func showFlashEffect() {
        showFlash = true
    }
}

struct ARVariables {
    static var arView: ARView?
}

// Preview provider
struct ARModeView_Previews: PreviewProvider {
    @State static var modelPlacement = false
    @State static var isLoading = false

    static var previews: some View {
        ARModeView(
            modelPlacement: $modelPlacement,
            isLoading: $isLoading,
            productTitle: "Sample Product",
            model3DURL: URL(string: "sample")!
        )
    }
}
