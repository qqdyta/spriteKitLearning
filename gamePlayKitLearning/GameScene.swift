//
//  GameScene.swift
//  gamePlayKitLearning
//
//  Created by 刘嘉麟 on 9/24/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var unitList : [UnitEntity] = []
    var unit : SKShapeNode!
    
    override func didMove(to view: SKView) {
        
        for _ in 1...200{
            
            let unitEntity = UnitEntity(
                targetNode: self,
                targetScene: self,
                view: view
            )
            unitList.append(unitEntity)
            let node = unitEntity.shapeNode
            self.unit = node
            self.addChild(node)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        for unit in unitList {
            let mouseInputHandle = unit.component(ofType: MoveComponent.self)
            mouseInputHandle?.handleMouseDown(event: event)
        }
    }
}
