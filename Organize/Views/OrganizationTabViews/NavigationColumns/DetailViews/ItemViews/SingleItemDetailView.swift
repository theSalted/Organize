//
//  SingleItemDetailView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/16/24.
//

import SwiftUI
import SceneKit

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
            
            if let previewImage = item.scan?.previewImage {
                Section {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            if let modelNode = item.scan?.modelNode {
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
        }
    }
}

#Preview {
    SingleItemDetailView(Item(name: "My Item"))
}
