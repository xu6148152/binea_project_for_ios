//
//  MainTabBarController.swift
//  SlidingMenuLikeQQ
//
//  Created by Binea Xu on 9/14/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.tag{
        case 0:
            Common.contactsVC.view.removeFromSuperview()
        case 1:
            break
        case 2:
            print("Just like case 1")
            
        default:
            break
        }
    }

}
