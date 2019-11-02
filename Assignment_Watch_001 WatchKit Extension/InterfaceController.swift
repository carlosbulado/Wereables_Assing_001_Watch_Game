//
//  InterfaceController.swift
//  Assignment_Watch_001 WatchKit Extension
//
//  Created by Carlos José Bulado on 2019-10-21.
//  Copyright © 2019 Carlos José Bulado. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController : WKInterfaceController
{
    var session : WCSession!
    var isGameRunning : Bool = false
    var startRestartPauseGameBtnState : Int = 0
    var seconds : Int = 0
    var powerUpPlusTimeSecond : Int = 0
    
    @IBOutlet weak var powerUpPlusTimeBtn: WKInterfaceButton!
    @IBOutlet weak var startGameBtn: WKInterfaceButton!
    @IBOutlet weak var currentGameTime: WKInterfaceLabel!
    @IBOutlet weak var points: WKInterfaceLabel!
    @IBOutlet weak var catMovement: WKInterfaceLabel!

    override func awake(withContext context: Any?)
    {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        initWCSessionDelegate()
    }
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        initWCSessionDelegate()
    }
    
    override func didDeactivate()
    {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func leftButtonTapped()
    {
        if self.session.isReachable
        {
            self.session.sendMessage(["Direction" : "Left"], replyHandler: nil)
            print("Message sent.")
        }
        else { print("No message was sent.") }
    }
    
    @IBAction func rightButtonTapped()
    {
        if self.session.isReachable
        {
            self.session.sendMessage(["Direction" : "Right"], replyHandler: nil)
            print("Message sent.")
        }
        else { print("No message was sent.") }
    }
    
    @IBAction func startGameTapped()
    {
        print("\(self.startRestartPauseGameBtnState)")
        if self.session.isReachable
        {
            if self.startRestartPauseGameBtnState == 0
            {
                self.session.sendMessage(["StartGame" : true], replyHandler: nil)
                print("Message sent.")
                
                self.stateBtn1()
            }
            else if self.startRestartPauseGameBtnState == 1
            {
                self.session.sendMessage(["PauseGame" : true], replyHandler: nil)
                print("Message sent.")
                
                self.stateBtn2()
            }
            else if self.startRestartPauseGameBtnState == 2
            {
                self.session.sendMessage(["ResumeGame" : true], replyHandler: nil)
                print("Message sent.")
                
                self.stateBtn1()
            }
        }
        else { print("No message was sent.") }
    }
    
    func stateBtn0()
    {
        self.isGameRunning = false
        self.startRestartPauseGameBtnState = 0
        self.startGameBtn.setTitle("Start Game")
    }
    
    func stateBtn1()
    {
        self.isGameRunning = true
        self.startRestartPauseGameBtnState = 1
        self.startGameBtn.setTitle("Pause Game")
    }
    
    func stateBtn2()
    {
        self.isGameRunning = false
        self.startRestartPauseGameBtnState = 2
        self.startGameBtn.setTitle("Resume Game")
    }
    
    @IBAction func powerUpPlusTapped()
    {
        if self.session.isReachable
        {
            self.session.sendMessage(["PowerUp" : "+Time"], replyHandler: nil)
            print("Message sent.")
        }
        else { print("No message was sent.") }

        self.powerUpPlusTimeBtn.setHidden(true)
        self.powerUpPlusTimeSecond = 0
    }
}

// Extension for implement WCSessionDelegate
extension InterfaceController : WCSessionDelegate
{
    func initWCSessionDelegate()
    {
        if WCSession.isSupported()
        {
            print("WC is supported!")
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
            
            self.session.sendMessage(["Direction" : "Right"], replyHandler: { (dict) -> Void in
                print("InterfaceController session response: \(dict)")
                }, errorHandler: { (error) -> Void in
                    print("InterfaceController session error: \(error)")
            })
            
        }
        else { print("WC NOT supported!") }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    {
        //print("WATCH: I received a message: \(message)")
        
        if message["CurrentGameTime"] != nil
        {
            let numLoops = message["CurrentGameTime"] as! NSNumber
            self.currentGameTime.setText("Time:  \(numLoops)")
            self.seconds = Int(truncating: numLoops)

            if self.seconds == 15
            {
                self.catMovement.setText("\(numLoops) seconds")
            }
            
            if self.seconds == 10
            {
                self.catMovement.setText("\(numLoops) seconds remaining")
            }
            
            if self.seconds == 5
            {
                self.catMovement.setText("\(numLoops) seconds remaining")
            }
            
            if self.powerUpPlusTimeSecond > 0 && self.powerUpPlusTimeSecond - 2 == self.seconds
            {
                self.powerUpPlusTimeBtn.setHidden(true)
                self.powerUpPlusTimeSecond = 0
            }
        }
        
        if message["Points"] != nil
        {
            let points = message["Points"] as! NSNumber
            self.points.setText("Points: \(points)")
        }
        
        if message["GameStatus"] != nil
        {
            let status = message["GameStatus"] as! String
            self.catMovement.setText("\(status)")
            
            if status == "GAME OVER!"
            {
                self.stateBtn0()
            }
        }
        
        if message["PowerUp"] != nil
        {
            let powerUp = message["PowerUp"] as! String
            if powerUp == "+Time"
            {
                self.powerUpPlusTimeSecond = self.seconds
                self.powerUpPlusTimeBtn.setHidden(false)
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { print("InterfaceController - session") }
}

