//
//  ViewController.swift
//  SimpleTest
//
//  Created by Dalton Cherry on 8/12/14.
//  Copyright (c) 2014 vluxe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ScaledroneDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Creating new Scaledrone instance")
        let sd = Scaledrone()
        sd.delegate = self
        sd.connect()
    }
    
    func onOpen(error: NSError?) {
        if (error != nil) {
            print(error!);
        }
        print("sd open")
    }
    
    func onError(error: NSError?) {
        if (error != nil) {
            print(error!);
        }
        print("sd error")
    }
}
