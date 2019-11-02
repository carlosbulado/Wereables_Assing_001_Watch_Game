//
//  GameViewController.swift
//  SushiTower
//
//  Created by ME
//  Copyright © 2019 Parrot. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import WatchConnectivity

class GameViewController : UIViewController
{
    var scene : GameScene! = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.scene = GameScene(size: self.view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        
        skView.showsPhysics = true
        
        skView.presentScene(scene)
    }
}
