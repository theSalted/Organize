//
//  ItemsBucketView.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import Foundation
import SwiftUI
import SpriteKit

struct ItemsBucketView: View {
    @Environment(\.colorScheme) private var colorScheme
    let scene: BucketGameScene
    let items: [Item]
    @State var selectedItem: Item? = nil
    @State var showDetailSheet: Bool = false
    
    init(
        _ items: [Item],
        scene: BucketGameScene = BucketGameScene()
    ) {
        self.scene = scene
        self.items = items
    }
    
    var body: some View {
        let itemNodeSpawnerComponent = ItemNodeSpawnerComponent(node: scene, items: items)
        let itemDetailMonitorComponent = ItemDetailMonitorComponent($selectedItem, showItemPreview: $showDetailSheet)
        
        SpriteView(scene: scene)
            .onChange(of: colorScheme) { _, _ in
                scene.backgroundColor = UIColor.systemBackground
            }
            .onAppear {
                scene.sceneEntity.addComponent(itemNodeSpawnerComponent)
                scene.sceneEntity.addComponent(itemDetailMonitorComponent)
            }
            .sheet(isPresented: $showDetailSheet) {
                if let selectedItem {
                    SingleItemDetailView(selectedItem)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    withAnimation {
                                        showDetailSheet = false
                                    }
                                }
                            }
                        }
                }
            }
    }
}
