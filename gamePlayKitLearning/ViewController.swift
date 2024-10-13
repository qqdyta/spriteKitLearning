//
//  ViewController.swift
//  gamePlayKitLearning
//
//  Created by 刘嘉麟 on 9/24/24.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.

        let scene = GameScene(size: CGSize(width: 640, height: 480))
        
        scene.scaleMode = .aspectFill
        
        if let view = self.skView{
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

