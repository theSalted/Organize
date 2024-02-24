//
//  ItemDetailMonitorComponent.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import GameplayKit
import SwiftUI
import SpriteKit
import OSLog

final class ItemDetailMonitorComponent: GKComponent {
    @Binding var selectedItem: Item?
    @Binding var showItemPreview: Bool
    
    init(_ selectedItem: Binding<Item?>, showItemPreview: Binding<Bool>) {
        self._selectedItem = selectedItem
        self._showItemPreview = showItemPreview
        super.init()
    }
    
    override func didAddToEntity() {
        logger.info("ItemDetailMonitorComponent is attached to an entity")
    }
    
    override func willRemoveFromEntity() {
        logger.info("ItemDetailMonitorComponent is removed from an entity")
    }
    
    func detect(_ node: SKNode) {
        guard let itemComponent = node.entity?.component(ofType: ItemComponent.self) else {
            logger.notice("ItemDetailMonitorComponent detected a node that doesn't have a item component")
            return
        }
        
        withAnimation {
            selectedItem = itemComponent.item
            showItemPreview = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "ItemDetailMonitorComponent")
