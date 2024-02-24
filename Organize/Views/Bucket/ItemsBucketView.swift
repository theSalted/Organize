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
    let scene: GameScene
    let items: [Item]
    
    init(
        _ items: [Item],
        scene: GameScene = GameScene()
    ) {
        self.scene = scene
        self.items = items
    }
    
    var body: some View {
        let itemNodeSpawnerComponent = ItemNodeSpawnerComponent(node: scene, items: items)
        SpriteView(scene: scene)
            .onChange(of: colorScheme) { _, _ in
                scene.backgroundColor = UIColor.systemBackground
            }
            .onAppear {
                scene.sceneEntity.addComponent(itemNodeSpawnerComponent)
            }
    }
}
