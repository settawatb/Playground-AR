//
//  FocusARView.swift
//  AR-Basic
//
//  Created by Settawat Buddhakanchana on 28/12/2566 BE.
//


import RealityKit
import FocusEntity
import Combine
import ARKit

class FocusARView: ARView {
    enum FocusStyleChoices {
        case classic
        case material
        case color
    }

    /// Style to be displayed in the example
    let focusStyle: FocusStyleChoices = .classic
    
    var focusEntity: FocusEntity?
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        self.setupConfig()

        switch self.focusStyle {
        case .color:
            self.focusEntity = FocusEntity(on: self, focus: .plane)
        case .material:
            do {
                let onColor: MaterialColorParameter = try .texture(.load(named: "Add"))
                let offColor: MaterialColorParameter = try .texture(.load(named: "Open"))
                self.focusEntity = FocusEntity(
                    on: self,
                    style: .colored(
                        onColor: onColor, offColor: offColor,
                        nonTrackingColor: offColor
                    )
                )
            } catch {
                self.focusEntity = FocusEntity(on: self, focus: .classic)
                print("Unable to load plane textures")
                print(error.localizedDescription)
            }
        default:
            self.focusEntity = FocusEntity(on: self, focus: .classic)
        }
    }

    func setupConfig() {
        // Place AR Object
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        // Improve Experience with LIDAR
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        self.session.run(config)
    }

    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
