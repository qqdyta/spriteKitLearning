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



class UnitEntity: GKEntity {
    
    var selfRadius: CGFloat
    var shapeNode: SKShapeNode
    var targetScene: SKScene
    
    init(targetNode: SKNode, targetScene: SKScene, view: SKView){
        
        self.targetScene = targetScene
        
        // 设置单位的大小
        let radius = 5.0
        
        // 创建颜色
        let randomColor = NSColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1
        )
        
        let shapeComponent = BaseUnitShapeComponent(
            radius: radius,
            color: randomColor
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
            color: randomColor,
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
        moveComponent.startRandomMovement()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
