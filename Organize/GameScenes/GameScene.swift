//
//  GameScene.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import CoreData
import CoreMotion
import SpriteKit
import GameplayKit
import OSLog

final class GameScene : SKScene, ObservableObject {
    var sceneEntity = GKEntity()
    var lastUpdateTimeInterval: TimeInterval = 0
    
    override func sceneDidLoad() {
        // Add color scheme (dark mode) and resize support to SpriteView
        #if canImport(UIKit)
        self.backgroundColor = UIColor.systemBackground
        #endif
        #if canImport(AppKit)
        self.backgroundColor = NSColor.windowBackgroundColor
        #endif
        
        self.scaleMode = .resizeFill
        logger.info("Game Scene successfully loaded")
    }
    
    override func didMove(to view: SKView) {
        #if !os(macOS)
        sceneEntity.addComponent(CoreMotionSceneComponent(scene: self))
        #endif
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        #if canImport(UIKit)
        self.backgroundColor = UIColor.systemBackground
        #endif
        #if canImport(AppKit)
        self.backgroundColor = NSColor.windowBackgroundColor
        #endif
        logger.info("Game Scene is presented into view")
    }
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = calculateDeltaTime(from: currentTime)
        sceneEntity.update(deltaTime: deltaTime)
    }
    
    #if !os(macOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)
        let touchedNode = self.atPoint(position)
        logger.debug("\(touchedNode.description) is created but not used, because touchbegan is not implemented")
        #warning("SpriteKit Detail Implementation go here")
    }
    #endif
    
    override func didChangeSize(_ oldSize: CGSize) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        if lastUpdateTimeInterval.isZero {
            lastUpdateTimeInterval = currentTime
        }
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        return deltaTime
    }
}

fileprivate let logger = Logger(subsystem: OrganizeApp.bundleId, category: "GameScene")
