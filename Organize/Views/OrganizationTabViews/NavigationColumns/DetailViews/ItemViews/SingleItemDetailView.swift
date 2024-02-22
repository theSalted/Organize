//
//  SingleItemDetailView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/16/24.
//

import SwiftUI
import SceneKit
import os

struct SingleItemDetailView: View {
    var item: Item
    
    init(_ item: Item) {
        self.item = item
    }
    
    var body: some View {
        List {
            Section {
                MetaPrimitiveView(item, title: "Information")
            }
            
            if let modelNode = item.capture?.modelNode {
                let scene: SCNScene = {
                    let scene = SCNScene()
                    scene.background.contents = UIColor.secondarySystemGroupedBackground
                    scene.rootNode.addChildNode(modelNode)
                    return scene
                }()
                
                SceneView(scene: scene,
                          options: [.allowsCameraControl, .autoenablesDefaultLighting],
                          antialiasingMode: .multisampling2X)
                .frame(height: 300)
            }
            
            if let previewImage = item.capture?.previewImage,
               let url = item.capture?.modelURL {
                Section {
                    Button {
                        openURL(from: url)
                    } label: {
                        Image(uiImage: previewImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
    
    private func openURL(from originalURL: URL) {
        let urlString = originalURL.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url) { success in
                if !success {
                    logger.warning("Couldn't open url: \(url.relativeString)")
                }
            }
        }
    }
}

#Preview {
    SingleItemDetailView(Item(name: "My Item"))
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "SingleItemDetailView")
