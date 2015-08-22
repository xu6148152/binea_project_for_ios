//
//  BaseTableViewController.swift
//  SportDemo
//
//  Created by Binea Xu on 8/16/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewController : UITableViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
}

extension UIViewController{
    static func instanceFromStoryboard(storyBoardName: String, viewControllerName: String)->UIViewController{
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(viewControllerName) as! UIViewController
    }
    
    static func instanceNavigationControllerFromStoryboard(storyBoardName: String, viewControllerName: String) -> UINavigationController{
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(viewControllerName) as! UINavigationController
    }
}