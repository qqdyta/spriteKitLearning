//
//  StaticFunction.swift
//  gamePlayKitLearning
//
//  Created by 刘嘉麟 on 10/13/24.
//
import AppKit
import SpriteKit

extension CGPoint {
    
    func distance(to point: CGPoint) -> CGFloat {
        let dx = point.x - x
        let dy = point.y - y
        return sqrt(dx*dx + dy*dy)
    }
}


func generateRandomColor() -> NSColor {
    
    return NSColor(
        red: CGFloat.random(in: 0...1),
        green: CGFloat.random(in: 0...1),
        blue: CGFloat.random(in: 0...1),
        alpha: 1
    )
}


func colorForUnitCount(_ count: Int, minCount: Int, maxCount: Int) -> NSColor {
    
    let clampedCount = max(min(count, maxCount), minCount)
    
    // 差值因子
    let t = CGFloat(clampedCount - minCount) / CGFloat(maxCount - minCount)
    
    let red =   t
    let green = 1.0 - t
    let blue =  0.0
    let alpha = 1.0
    
    return NSColor(red: red, green: green, blue: blue, alpha: alpha)
}


func getRandomStartPosition(_ range: CGFloat, targetScene: SKScene) -> CGPoint {
    
    let x = targetScene.size.width / 2
    let y = targetScene.size.height / 2
    
    let randomX = CGFloat.random(in: (x - range)...(x + range))
    let randomY = CGFloat.random(in: (y - range)...(y + range))
    
    return CGPoint(x: randomX, y: randomY)
}
