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
        
//        self.initWCSessionDelegate()
    }
}

// Extension for implement WCSessionDelegate
//extension GameViewController : WCSessionDelegate
//{
//    func initWCSessionDelegate()
//    {
//        if WCSession.isSupported()
//        {
//            print("WC is supported!")
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//        }
//        else { print("WC NOT supported!") }
//    }
//
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
//    {
//        print("PHONE: I received a message: \(message)")
//        let direction = message["Direction"] as! String
//
//        if direction == "Left" { self.scene.moveLeft() }
//        if direction == "Right" { self.scene.moveRight() }
//    }
//
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { print("GameViewController - session") }
//
//    func sessionDidBecomeInactive(_ session: WCSession) { print("GameViewController - sessionDidBecomeInactive") }
//
//    func sessionDidDeactivate(_ session: WCSession) { print("GameViewController - sessionDidDeactivate") }
//}
