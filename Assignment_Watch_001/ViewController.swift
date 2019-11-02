////
////  ViewController.swift
////  Assignment_Watch_001
////
////  Created by Carlos José Bulado on 2019-10-21.
////  Copyright © 2019 Carlos José Bulado. All rights reserved.
////
//
//import UIKit
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//
//}
//

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

class ViewController : UIViewController
{
    var scene : GameScene! = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.scene = GameScene(size:self.view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        
        // property to show hitboxes
        skView.showsPhysics = true
        
        skView.presentScene(scene)
    }

  
}
