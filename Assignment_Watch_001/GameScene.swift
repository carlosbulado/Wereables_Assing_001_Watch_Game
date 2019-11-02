//
//  GameScene.swift
//  SushiTower
//
//  Created by ME
//  Copyright © 2019 Parrot. All rights reserved.
//

import SpriteKit
import GameplayKit
import WatchConnectivity

class GameScene: SKScene
{
    var session : WCSession!
    var isGameRunning : Bool = false
    
    let cat = SKSpriteNode(imageNamed: "character1")
    let sushiBase = SKSpriteNode(imageNamed:"roll")

    var sushiTower : [SKSpriteNode] = []
    let SUSHI_PIECE_GAP : CGFloat = 80

    var chopstickGraphicsArray : [SKSpriteNode] = []
    
    var catPosition : String = "left"
    var chopstickPositions : [String] = []
    
    var catMove : Bool = false
    var lose : Bool = false
    
    var numLoops : Int = 0
    var seconds : Int = 25
    var lastCurrentTime : Int = 0
    var catHitsBranch : Bool = false
    
    var points : Int = 0
    
    func spawnSushi()
    {
        let sushi = SKSpriteNode(imageNamed:"roll")
        
        if (self.sushiTower.count == 0)
        {
            sushi.position.y = sushiBase.position.y
                + SUSHI_PIECE_GAP
            sushi.position.x = self.size.width*0.5
        }
        else
        {
            let previousSushi = sushiTower[self.sushiTower.count - 1]
            sushi.position.y = previousSushi.position.y + SUSHI_PIECE_GAP
            sushi.position.x = self.size.width*0.5
        }
        
        addChild(sushi)
        
        self.sushiTower.append(sushi)
        
        let stickPosition = Int.random(in: 1...2)
        if (stickPosition == 1) {
            // save the current position of the chopstick
            self.chopstickPositions.append("right")
            
            // draw the chopstick on the screen
            let stick = SKSpriteNode(imageNamed:"chopstick")
            stick.position.x = sushi.position.x + 100
            stick.position.y = sushi.position.y - 10
            // add chopstick to the screen
            addChild(stick)
            
            // add the chopstick object to the array
            self.chopstickGraphicsArray.append(stick)
            
            // redraw stick facing other direciton
            let facingRight = SKAction.scaleX(to: -1, duration: 0)
            stick.run(facingRight)
        }
        else if (stickPosition == 2) {
            // save the current position of the chopstick
            self.chopstickPositions.append("left")
            
            // left
            let stick = SKSpriteNode(imageNamed:"chopstick")
            stick.position.x = sushi.position.x - 100
            stick.position.y = sushi.position.y - 10
            // add chopstick to the screen
            addChild(stick)
            
            // add the chopstick to the array
            self.chopstickGraphicsArray.append(stick)
        }
    }
    
    override func didMove(to view: SKView)
    {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        
        cat.position = CGPoint(x:self.size.width*0.25, y:100)
        addChild(cat)
        
        sushiBase.position = CGPoint(x:self.size.width*0.5, y: 100)
        addChild(sushiBase)
        
        self.buildTower()
        
        self.initWCSessionDelegate()
    }
    
    func buildTower()
    {
        for _ in 0...8
        {
            self.spawnSushi()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        if self.isGameRunning
        {
            if self.seconds <= 0
            {
                // YOU LOST
                self.youLost()
            }
            
            self.numLoops = self.numLoops + 1

            if self.catMove
            {
                self.spawnSushi()
                self.catMove = false
            }
            
            if self.sushiTower.count < 10
            {
                for _ in self.sushiTower.count...10
                {
                    self.spawnSushi()
                }
            }

            self.sendCurrentTime(currentTime)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if self.isGameRunning
        {
            guard let mousePosition = touches.first?.location(in: self) else {
                return
            }

            let pieceToRemove = self.sushiTower.first
            let stickToRemove = self.chopstickGraphicsArray.first
            
            if (pieceToRemove != nil && stickToRemove != nil)
            {
                pieceToRemove!.removeFromParent()
                self.sushiTower.remove(at: 0)
            
                stickToRemove!.removeFromParent()
                self.chopstickGraphicsArray.remove(at:0)
                
                self.chopstickPositions.remove(at:0)
                
                for piece in sushiTower {
                    piece.position.y = piece.position.y - SUSHI_PIECE_GAP
                }
                
                for stick in chopstickGraphicsArray {
                    stick.position.y = stick.position.y - SUSHI_PIECE_GAP
                }
            }
            
            let middleOfScreen  = self.size.width / 2
            
            if mousePosition.x < middleOfScreen { self.moveLeft() }
            else { self.moveRight() }
        }
    }
    
    func moveLeft()
    {
        if !self.lose
        {
            cat.position = CGPoint(x: self.size.width * 0.25, y: 100)
            
            let facingRight = SKAction.scaleX(to: 1, duration: 0)
            self.cat.run(facingRight)
            
            self.catPosition = "left"
            self.catMove = true
            
            if self.session.isReachable
            {
                let message = ["CatMovement" : "LEFT"] as [String : Any]
                self.session.sendMessage(message, replyHandler: nil)
            }
            else { print("No message was sent.") }
            
            self.finishMovement()
        }
    }
    
    func moveRight()
    {
        if !self.lose
        {
            cat.position = CGPoint(x: self.size.width * 0.75, y: 100)
            
            let facingLeft = SKAction.scaleX(to: -1, duration: 0)
            self.cat.run(facingLeft)
            
            self.catPosition = "right"
            self.catMove = true
            
            if self.session.isReachable
            {
                let message = ["CatMovement" : "RIGHT"] as [String : Any]
                self.session.sendMessage(message, replyHandler: nil)
            }
            else { print("No message was sent.") }
            
            self.finishMovement()
        }
    }
    
    func finishMovement()
    {
        let image1 = SKTexture(imageNamed: "character1")
        let image2 = SKTexture(imageNamed: "character2")
        let image3 = SKTexture(imageNamed: "character3")
        
        let punchTextures = [image1, image2, image3, image1]
        
        let punchAnimation = SKAction.animate(
            with: punchTextures,
            timePerFrame: 0.1)
        
        self.cat.run(punchAnimation)
        
        let firstChopstick = self.chopstickPositions[0]
        if (catPosition == "left" && firstChopstick == "left") { self.catHitsBranch = true }
        else if (catPosition == "right" && firstChopstick == "right") { self.catHitsBranch = true }
        else if (catPosition == "left" && firstChopstick == "right")
        {
            // POINT
            self.points = self.points + 1
            //self.seconds = self.seconds + 1
            self.sendPoints()
        }
        else if (catPosition == "right" && firstChopstick == "left")
        {
            // POINT
            self.points = self.points + 1
            //self.seconds = self.seconds + 1
            self.sendPoints()
        }

        if self.catHitsBranch
        {
            // HIT BRANCH
            //self.seconds = self.seconds - 5
            //self.points = self.points - 4
            if self.points < 0
            {
                self.points = 0
            }
            self.sendPoints()
        }
        
        self.catHitsBranch = false
    }
    
    func initGame()
    {
        self.seconds = 25
        self.numLoops = 0
        self.points = 0
        self.catMove = false
        self.lose = false
    }
    
    func youLost()
    {
        if self.session.isReachable
        {
            let message = ["GameStatus" : "GAME OVER!"] as [String : Any]
            self.session.sendMessage(message, replyHandler: nil)
        }
        else { print("No message was sent.") }
        
        self.lose = true
        self.isGameRunning = false
    }
    
    func startRestartGame()
    {
        self.catMove = false
        self.lose = false
        self.numLoops = 0
        self.seconds = 25
        self.lastCurrentTime = 0
        self.catHitsBranch = false
        self.points = 0
        self.isGameRunning = true
    }
}

// Extension for implement WCSessionDelegate
extension GameScene : WCSessionDelegate
{
    func initWCSessionDelegate()
    {
        if WCSession.isSupported()
        {
            print("WC is supported!")
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
        else { print("WC NOT supported!") }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    {
        print("PHONE: I received a message: \(message)")
        
        if let directionValue = message["Direction"]
        {
            let direction = directionValue as? String
            
            if direction == "Left" { self.moveLeft() }
            if direction == "Right" { self.moveRight() }
        }

        if let startGameValue = message["StartGame"]
        {
            let isGameStart = startGameValue as! Bool
            if isGameStart
            {
                self.startRestartGame()
            }
        }

        if let resumeGameValue = message["ResumeGame"]
        {
            let isGameStart = resumeGameValue as! Bool
            if isGameStart
            {
                self.isGameRunning = true
            }
        }

        if let pauseGameValue = message["PauseGame"]
        {
            let isGameStart = pauseGameValue as! Bool
            if isGameStart
            {
                self.isGameRunning = false
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { print("GameScene - session") }
    
    func sessionDidBecomeInactive(_ session: WCSession) { print("GameScene - sessionDidBecomeInactive") }
    
    func sessionDidDeactivate(_ session: WCSession) { print("GameScene - sessionDidDeactivate") }
    
    func sendCurrentTime(_ currentTime: TimeInterval)
    {
        if self.session.isReachable
        {
            let now : Int = Int(currentTime)
            if now > self.lastCurrentTime
            {
                self.seconds = self.seconds - 1
                self.session.sendMessage(["CurrentGameTime" : self.seconds], replyHandler: nil)
            }
        }
        else { print("No message was sent.") }

        self.lastCurrentTime = Int(currentTime)
    }
    
    func sendPoints()
    {
        if self.session.isReachable
        {
            self.session.sendMessage(["Points" : self.points], replyHandler: nil)
            print("Message with points: \(self.points)")
        }
        else { print("No message was sent.") }
    }
}
