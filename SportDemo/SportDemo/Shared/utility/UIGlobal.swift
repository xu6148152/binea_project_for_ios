//
//  UIGlobal.swift
//  SportDemo
//
//  Created by Binea Xu on 8/9/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

class UIGlobal{
    
    static func appWindow() -> UIWindow {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).appWindow!
    }
}