//
//  ViewController.swift
//  SimpleTest
//
//  Created by Dalton Cherry on 8/12/14.
//  Copyright (c) 2014 vluxe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ScaledroneDelegate, ScaledroneRoomDelegate {
    
    let scaledrone = Scaledrone()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Creating new Scaledrone instance")
        scaledrone.delegate = self
        scaledrone.connect()
    }
    
    func scaledroneDidConnect(scaledrone: Scaledrone, error: NSError?) {
        if (error != nil) {
            print(error!);
        }
        print("sd open", scaledrone.clientID)
        let room = scaledrone.subscribe(roomName: "notifications")
        room.delegate = self
    }
    
    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: NSError?) {
        if (error != nil) {
            print(error!);
        }
        print("sd error")
    }
    
    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: NSError?) {
        print("room connected", room)
    }
    
    func scaledroneRoomDidReceiveMessage(room: ScaledroneRoom, message: String) {
        print("received message", message)
    }
}
