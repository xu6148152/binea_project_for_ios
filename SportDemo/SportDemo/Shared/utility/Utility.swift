//
//  Utility.swift
//  SportDemo
//
//  Created by Binea Xu on 8/8/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

class Utility{
    static func getTopmostViewController() -> UIViewController{
        var vc = UIGlobal.appWindow().rootViewController
        if let tmpVc = vc as? UITabBarController {
            vc = tmpVc
        }
        
        while true{
            if let tmpVc = vc as? UINavigationController{
                vc = tmpVc.topViewController
            }else if let tmpVc = vc?.presentedViewController {
                return tmpVc
            }
            
            while let tmpVc = vc?.presentedViewController {
                vc = tmpVc
            }
        }
    }
    
    
}