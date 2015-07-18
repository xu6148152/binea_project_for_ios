//
//  AppDelegate.swift
//  Trax
//
//  Created by Binea Xu on 7/18/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

struct GPXURL {
    static let notification = "GPXURL Radio station"
    static let key = "GPXURL URL KEY"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        println("url = \(url)")
        
        let center = NSNotificationCenter.defaultCenter();
        let notification = NSNotification(name: GPXURL.notification, object: self, userInfo: [GPXURL.key : url])
        center.postNotification(notification)
        return true
    }

}

