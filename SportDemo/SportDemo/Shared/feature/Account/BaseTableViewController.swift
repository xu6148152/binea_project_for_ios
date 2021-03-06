//
//  BaseTableViewController.swift
//  SportDemo
//
//  Created by Binea Xu on 8/16/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewController : UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
    func configureNavigation(){
//        var items = NSMutableArray()
//        
//        if (self.navigationItem.leftBarButtonItems != nil) {
//            items.addObjectsFromArray(self.navigationItem.leftBarButtonItems!)
//        }
//        if (self.navigationItem.rightBarButtonItems != nil) {
//            items.addObjectsFromArray(self.navigationItem.rightBarButtonItems!)
//        }
        
//        for var item in items {
//            let tmpItem = item as! UIBarButtonItem
//            tmpItem.image = UIImage(named: tmpItem.image)
//        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
//        self.navigationItem.backBarButtonItem?.accessibilityLabel = "top back"
//        self.navigationItem.accessibilityLabel = "top title"

    }
}

extension UIViewController{
    static func instanceFromStoryboard(storyBoardName: String, viewControllerName: String)->UIViewController{
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(viewControllerName) 
    }
    
    static func instanceNavigationControllerFromStoryboard(storyBoardName: String, viewControllerName: String) -> UINavigationController{
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(viewControllerName) as! UINavigationController
    }
}