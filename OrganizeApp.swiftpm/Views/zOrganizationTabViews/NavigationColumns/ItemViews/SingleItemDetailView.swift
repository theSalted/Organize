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
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                HStack(spacing: 10) {
                    IconNameCardView(item, mode: .display)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    if let image = item.image {
                        ZStack {
                            Rectangle().foregroundStyle(Color(uiColor: .secondarySystemBackground))
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .frame(height: 250)
                
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
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(height: 300)
                }
                
                if item.subjectMaskedImage != nil ||
                    item.capture?.previewImage != nil
                {
                    HStack(spacing: 10) {
                        if let image = item.subjectMaskedImage {
                            ZStack {
                                Rectangle().foregroundStyle(Color(uiColor: .secondarySystemBackground))
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .padding()
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        if let previewImage = item.capture?.previewImage {
                            ZStack {
                                Color.white
                                Image(uiImage: previewImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .frame(height: 300)
                }
                
                HStack(spacing: 10) {
                    CurtainStack(folds: 10) {
                        GroupBox {
                            MetaPrimitiveView(item, title: "Information")
                        }
                    } background: {
                        Text("Hey! You found me.")
                    }
                }
                .gridCellColumns(2)
            }
            .padding()
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
