//
//  ViewController.swift
//  SimpleTest
//
//  Created by Dalton Cherry on 8/12/14.
//  Copyright (c) 2014 vluxe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ScaledroneDelegate {
    
    let sd = Scaledrone()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Creating new Scaledrone instance")
        sd.delegate = self
        sd.connect()
    }
    
    func scaledroneDidConnect(scaledrone: Scaledrone, error: NSError?) {
        if (error != nil) {
            print(error!);
        }
        print("sd open", scaledrone.clientID)
    }
    
    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: NSError?) {
        if (error != nil) {
            print(error!);
        }
        print("sd error")
    }
}
