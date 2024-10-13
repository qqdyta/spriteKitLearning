//
//  GameScene.swift
//  gamePlayKitLearning
//
//  Created by 刘嘉麟 on 9/24/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var unitEntity: UnitEntity!
    var unit : SKShapeNode!
    
    override func didMove(to view: SKView) {
        unitEntity = UnitEntity(
            targetNode: self,
            targetScene: self,
            radius: 5,
            view: view
        )
        
        let node = unitEntity.shapeNode
        self.unit = node
        self.addChild(node)
    }
    
    override func mouseDown(with event: NSEvent) {
        
        let mouseInputHandle = unitEntity.component(ofType: MoveComponent.self)
        mouseInputHandle?.handleMouseDown(event: event)
    }
}
