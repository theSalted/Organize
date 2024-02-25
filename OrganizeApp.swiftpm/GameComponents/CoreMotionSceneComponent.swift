//
//  CoreMotionSceneComponent.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import CoreMotion
import GameplayKit
import SpriteKit
import OSLog

#if !os(macOS)
final class CoreMotionSceneComponent: GKComponent {
    let logger = Logger()
    private var scene: SKScene
    private let motionManager = CMMotionManager()
    
    init(scene: SKScene) {
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        motionManager.accelerometerUpdateInterval = 1/10
        motionManager.startAccelerometerUpdates()
        logger.info("CoreMotionSceneComponent is attached to Game Scene")
    }
    
    override func willRemoveFromEntity() {
        scene.physicsWorld.gravity = CGVector(dx: 9.8, dy: -9.8)
        logger.info("CoreMotionSceneComponent is removed to Game Scene")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            var accelerX = 0.0
            var accelerY = -1.0
            switch UIDevice.current.orientation{
            case .portrait:
                accelerX = accelerometerData.acceleration.x
                accelerY = accelerometerData.acceleration.y
            case .portraitUpsideDown:
                accelerX = -accelerometerData.acceleration.x
                accelerY = -accelerometerData.acceleration.y
            case .landscapeLeft:
                accelerX = -accelerometerData.acceleration.y
                accelerY = accelerometerData.acceleration.x
            case .landscapeRight:
                accelerX = accelerometerData.acceleration.y
                accelerY = -accelerometerData.acceleration.x
            default:
                break
            }
            
            scene.physicsWorld.gravity = CGVector(dx: accelerX * 9.8, dy: accelerY * 9.8)
        }
    }
}
#endif

