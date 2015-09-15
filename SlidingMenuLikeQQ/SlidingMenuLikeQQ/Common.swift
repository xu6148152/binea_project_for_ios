//
//  Common.swift
//  SlidingMenuLikeQQ
//
//  Created by Binea Xu on 9/14/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit

struct Common{
    
    static let screenWidth = UIScreen.mainScreen().applicationFrame.maxX
    static let screenHeight = UIScreen.mainScreen().applicationFrame.maxY
    static let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as! ViewController
    static let contactsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Contacts")
}