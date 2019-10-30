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
        print("WATCH: I received a message: \(message)")
        
        if message["CurrentGameTime"] != nil
        {
            let numLoops = message["CurrentGameTime"] as! NSNumber
            self.currentGameTime.setText("Time:  \(numLoops)")
        }
        
        if message["CatMovement"] != nil
        {
            let catMovement = message["CatMovement"] as! String
            self.catMovement.setText("Cat: \(catMovement)")
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
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { print("InterfaceController - session") }
}

