//
//  UnitComponents.swift
//  gamePlayKitLearning
//
//  Created by 刘嘉麟 on 10/13/24.
//

import AppKit
import GameplayKit
import SpriteKit


class BaseUnitShapeComponent: GKComponent {
    
    let shapeNode: SKShapeNode
    
    init(radius: CGFloat, color: SKColor) {
        
        self.shapeNode = SKShapeNode(circleOfRadius: radius)
        self.shapeNode.fillColor = color
        self.shapeNode.strokeColor = color
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BaseTrailComponent: GKComponent {
    
    var trailEmitter: SKEmitterNode?
    var baseTexture: SKTexture?
    var selfRadius: CGFloat?
    
    init(
        targetNode: SKNode,
        color: SKColor,
        view: SKView,
        radius: CGFloat,
        targetScene: SKScene
    ){
        super.init()
        self.selfRadius = radius
        let circlePath = CGPath(
            ellipseIn: CGRect(x: (radius / 5 * 3), y: (radius / 5 * 3), width: 12, height: 12),
               transform: nil
           )
        let shapeNode = SKShapeNode(path: circlePath)
         shapeNode.fillColor = color
         shapeNode.strokeColor = .clear
        baseTexture = view.texture(from: shapeNode)
        trailEmitter = SKEmitterNode()
        trailEmitter?.particleColor = .red
        trailEmitter?.particleBirthRate = 40
        trailEmitter?.particleLifetime = 0.2
        trailEmitter?.particleSpeed = 0
        trailEmitter?.particleAlpha = 0.5
        trailEmitter?.particleScaleSpeed = -5
        trailEmitter?.targetNode = targetScene
        trailEmitter?.emissionAngle = .pi * 2
        trailEmitter?.particleTexture = baseTexture
        trailEmitter?.advanceSimulationTime(1)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attachNode(_ node: SKNode){
        if let trail = trailEmitter {
            node.addChild(trail)
        }
    }
}


class MoveComponent: GKComponent {
    
    var node: SKNode
    var scene: SKScene
    
    init(node: SKNode, scene: SKScene){
        
        self.node = node
        self.scene = scene
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleMouseDown(event: NSEvent){
        
        // 清除之前所有的动作
        node.removeAllActions()
        
        //创建移动的动作
        let targetPosition = event.location(in: self.scene)
        let moveAction = SKAction.move(to: targetPosition, duration: 2)
        
        //当节点移动到目标位置以后恢复随机的移动
        let completionAction = SKAction.run {
            [weak self] in
            self?.startRandomMovement()
        }
        let sequence = SKAction.sequence([moveAction, completionAction])
        node.run(sequence)
    }
    
    func startRandomMovement(){
        
        node.removeAllActions()
        
        let randomMoveAction = createRandomMoveAction()
        node.run(randomMoveAction, withKey: "randomMovement")
    }
    
    func createRandomMoveAction() -> SKAction {
        
        let position = node.position
        let range: CGFloat = 20
        let duration: CGFloat = 2
        
        let minX = max(position.x - range, 0)
        let maxX = min(position.x + range, scene.size.width)
        let minY = max(position.y - range, 0)
        let maxY = min(position.y + range, scene.size.height)
        
        if(minX > maxX){
            print(
                "position.x: \(position.x), scene.size.width:\(scene.size.width)"
            )
        }
        if(minY >= maxY){
            print(
                "positon.y:\(position.y), scene.size.height: \(scene.size.height)"
            )
        }
        
        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)
        let randomPosition = CGPoint(x: randomX, y: randomY)
        
        let moveAction = SKAction.move(to: randomPosition, duration: duration)
        let moveSquence = SKAction.sequence([moveAction, SKAction.run {
            [weak self] in
            self?.startRandomMovement()
        }])
        
        return moveSquence
    }
    
}


class ProximityComponent: GKComponent {
    
    var radius: CGFloat
    
    init(radius: CGFloat) {
        
        self.radius = radius
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func unitsInRange() -> [UnitEntity] {
        
        guard let unitEntity = self.entity as? UnitEntity else {
            return []
        }
        
        let myPosition = unitEntity.shapeNode.position
        let allUnits = UnitManager.shared.getAllUnits()
        var unitsInRange: [UnitEntity] = []
        for unit in allUnits {
            if unit === unitEntity{
                continue
            }
            
            let otherPosition = unit.shapeNode.position
            let distance = myPosition.distance(to: otherPosition)
            if distance <= radius {
                unitsInRange.append(unit)
            }
        }
        return unitsInRange
    }
}
