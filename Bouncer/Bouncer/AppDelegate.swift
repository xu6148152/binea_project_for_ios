//
//  AppDelegate.swift
//  Bouncer
//
//  Created by Binea Xu on 7/18/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    struct Motion{
        static let motionManager = CMMotionManager()
    }

}

