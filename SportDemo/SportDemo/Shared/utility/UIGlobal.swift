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
    
    static var ZEPPGREENCOLOR: UIColor{
        get{
            return UIColorFromARGB(0xD1EE00)
        }
    }
    
    static func appWindow() -> UIWindow {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).appWindow!
    }
    
    static func UIColorFromARGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat((rgbValue & 0xff000000 > 0 ? ((Float)((rgbValue & 0xFF000000) >> 24))/255.0 : 1.0))
        )
    }
}