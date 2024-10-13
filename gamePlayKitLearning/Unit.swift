//
//  Unit.swift
//  gamePlayKitLearning
//
//  Created by 刘嘉麟 on 9/24/24.
//
import SpriteKit
import GameplayKit


class UnitEntity: GKEntity {
    
    var shapeNode: SKShapeNode
    var targetScene: SKScene
    
    init(targetNode: SKNode, targetScene: SKScene, view: SKView){
        
        self.targetScene = targetScene
        
        // 设置单位的大小
        let radius = 5.0
        
        // 创建颜色
        let color = generateRandomColor()
        
        let shapeComponent = BaseUnitShapeComponent(
            radius: radius,
            color: color
        )
        let node = shapeComponent.shapeNode
        self.shapeNode = node
        super.init()
        
        UnitManager.shared.addUnit(self)
        
        // 设置初始位置
        self.shapeNode.position = getRandomStartPosition(
            100,
            targetScene: targetScene
        )
        self.addComponent(shapeComponent)
        
        let trailComponent = BaseTrailComponent(
            targetNode: self.shapeNode,
            color: color,
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
    
    deinit{
        
        UnitManager.shared.removeUnit(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func countUnitsInRange(radius: CGFloat) -> Int {
        
        let myPosition = self.shapeNode.position
        let allUnits = UnitManager.shared.getAllUnits()
        
        var count = 0
        for unit in allUnits {
            if unit === self {
                continue
            }
            
            let otherPostion = unit.shapeNode.position
            let distance = myPosition.distance(to: otherPostion)
            if distance <= radius {
                count += 1
            }
        }
        
        return count
    }
}


class UnitManager {
    
    static let shared = UnitManager()
    private init(){}
    
    private var units: [UnitEntity] = []
    
    func addUnit(_ unit: UnitEntity){
        units.append(unit)
    }
    
    func removeUnit(_ unit: UnitEntity){
        units.removeAll(){$0 === unit}
    }
    
    func getAllUnits() ->[UnitEntity]{
        return units
    }
}
