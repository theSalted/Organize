//
//  ItemComponent.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import GameplayKit
import OSLog

final class ItemComponent: GKComponent {
    var item: Item
    
    init(_ item: Item) {
        self.item = item
        super.init()
    }
    
    override func didAddToEntity() {
        logger.info("ItemComponent is added to an entity")
    }
    
    override func willRemoveFromEntity() {
        logger.info("ItemComponent is removed from an entity")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "ItemComponent")
