//
//  ItemNodeSpawnerComponent.swift
//  Organize
//
//  Created by Yuhao Chen on 2/24/24.
//

import Foundation
import SpriteKit
import OSLog
import GameplayKit

final class ItemNodeSpawnerComponent: GKComponent {
    var node: SKNode
    var items = [Item]()
    var maximumNode = 10
    
    init(node: SKNode, items: [Item] = [Item]()) {
        self.node = node
        self.items = items
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        logger.info("MetaNodeSpawnerComponent is attached to An Entity")
        placeConfiguredNodeAtRandomLocation()
    }
    
    override func willRemoveFromEntity() {
        logger.info("MetaNodeSpawnerComponent is removed from An Entity")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if node.children.count <= maximumNode, // Number of nodes is smaller than maximum
           1 == Int.random(in: 1...100)// 1 in 100 chances
        {
            placeConfiguredNodeAtRandomLocation()
        }
    }
    
    private func placeConfiguredNodeAtRandomLocation() {
        guard let configuredNode = generateConfiguredNode() else {
            return
        }
        
        let randomizer = CGFloat.random(in: 0...1)
        
        configuredNode.position = CGPoint(
            x: randomizer * node.frame.width,
            y: node.frame.height - 100)
        
        node.addChild(configuredNode)
    }
    
    /// Generates a new `SKNode` with predefined physics, position, and animations. This node is created based on a random item's properties
    /// using the `randomNewNode` helper function. Once created, the node is configured with a physics body, z-position, and initial transparency.
    /// It is then animated with a sequence of actions including fading in, applying an impulse, waiting, fading out, and finally removal from the parent.
    ///
    /// - Returns: An optional `SKNode` configured with physics and animations. Returns `nil` if `randomNewNode` fails to create a node.
    private func generateConfiguredNode() -> SKNode? {
        guard let node = randomNewNode() else {
            return nil
        }
        
        // Configure node properties and physics body
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 80), center: CGPoint(x: 0, y: 0))
        node.zPosition = -10
        node.alpha = 0
        
        // Define random adjustments and forces for animation
        let randomAdjustment = CGVector(dx: CGFloat(Int.random(in: -40...40)),
                                        dy: CGFloat(Int.random(in: -10...25)))
        let randomForce = CGVector(dx: randomAdjustment.dx / 3,
                                   dy: CGFloat(Int.random(in: 15...25)))
        
        // Animate node with a sequence of actions
        node.run(
            .sequence([
                .fadeIn(withDuration: 1),
                .applyImpulse(randomForce, duration: 0.1),
                .wait(forDuration: 10.0),
                .fadeOut(withDuration: 0.5),
                .removeFromParent()
            ])
        )
        
        return node
    }
    
    /// Attempts to create a new `SKNode` based on a random item from a collection. The node is created in one of the following ways:
    /// - If the item contains an image, a `SKSpriteNode` with the image is created.
    /// - If the item's symbol is a single emoji, an `SKLabelNode` with the emoji as its text is created.
    /// - If the item's symbol can be used to create a system image, a `SKSpriteNode` with this system image is created.
    /// If none of these conditions are met, the function fails to create a node and logs a warning.
    ///
    /// - Returns: An optional `SKNode`. Returns `nil` if the `items` collection is empty or the item's symbol is unrecognized.
    private func randomNewNode() -> SKNode? {
        guard let randomItem = items.randomElement() else {
            logger.warning("Failed to create a node: 'items' collection is empty.")
            return nil
        }
        
        if let image = randomItem.subjectMaskedImage {
            let spriteNode = createSpriteNode(from: image)
            spriteNode.scale(to: CGSize(width: 100, height: 100))
            spriteNode.entity?.addComponent(ItemComponent(randomItem))
            return spriteNode
        }
        
        logger.warning("Failed to create a node: Unrecognized symbol '\(randomItem.symbol)'.")
        return nil
    }
    
    /// Creates a `SKSpriteNode` from a given `UIImage`.
    ///
    /// - Parameter image: The `UIImage` to use for creating the texture of the sprite node.
    /// - Returns: A `SKSpriteNode` with a texture created from the given image.
    private func createSpriteNode(from image: UIImage) -> SKSpriteNode {
        let texture = SKTexture(image: image)
        return SKSpriteNode(texture: texture)
    }
    
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "ItemNodeSpawnerComponent")
