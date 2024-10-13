//
//  Unit.swift
//  gamePlayKitLearning
//
//  Created by 刘嘉麟 on 9/24/24.
//
import SpriteKit
import GameplayKit


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
         shapeNode.fillColor = .green
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
        
        let targetPosition = event.location(in: self.scene)
        let moveAction = SKAction.move(to: targetPosition, duration: 2)
        node.run(moveAction)
    }
}



class UnitEntity: GKEntity {
    
    var selfRadius: CGFloat
    var shapeNode: SKShapeNode
    
    init(targetNode: SKNode, targetScene: SKScene, radius: CGFloat, view: SKView){
        
        let shapeComponent = BaseUnitShapeComponent(
            radius: radius,
            color: .green
        )
        self.selfRadius = radius
        let node = shapeComponent.shapeNode
        self.shapeNode = node
        super.init()
        
        // 设置初始位置
        let randomX = CGFloat.random(in: targetScene.size.width * 0.25...targetScene.size.width * 0.75)
        let randomY = CGFloat.random(in: targetScene.size.height * 0.25...targetScene.size.height * 0.75)
        self.shapeNode.position = CGPoint(x: randomX, y: randomY)
        self.addComponent(shapeComponent)
    
        
        let trailComponent = BaseTrailComponent(
            targetNode: self.shapeNode,
            color: .red,
            view: view,
            radius: radius,
            targetScene: targetScene
        )
        self.addComponent(trailComponent)
        trailComponent.attachNode(node)
        
        
        let moveComponent = MoveComponent(
            node: self.shapeNode,
            scene: targetScene
        )
        self.addComponent(moveComponent)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
