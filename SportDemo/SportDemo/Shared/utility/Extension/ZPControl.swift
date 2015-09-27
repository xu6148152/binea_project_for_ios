//
//  ZPControl.swift
//  SportDemo
//
//  Created by Binea Xu on 9/27/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import Foundation

class ZPControl{
    
    typealias ZPCompleteAction = (() -> Bool)?
    
    static func topViewController() -> UIViewController {
        var rootViewController = UIGlobal.appWindow().rootViewController
        
        if (rootViewController?.isKindOfClass(UITabBarController) != nil) {
            rootViewController = (rootViewController as! UITabBarController).selectedViewController
        }
        
        while true{
            if (rootViewController?.isKindOfClass(UINavigationController) != nil) {
                let vc = rootViewController as! UINavigationController
                rootViewController = vc.topViewController
            }else if (rootViewController?.isKindOfClass(UISplitViewController) != nil
                && (rootViewController as! UISplitViewController).viewControllers.last != nil) {
                rootViewController = (rootViewController as! UISplitViewController).viewControllers.last
            }else if (rootViewController?.presentedViewController != nil){
                return rootViewController!
            }
            
            while rootViewController?.presentedViewController != nil {
                rootViewController = rootViewController?.presentedViewController
            }
        }
    }
    
    
    static func presentViewController(viewControllerToPresent: UIViewController, animated: Bool, modalPresentationStyle: UIModalPresentationStyle, completion: () -> Void) {
        presentViewController(viewControllerToPresent, animated: animated, modalPresentationStyle: modalPresentationStyle, withDismissButton: true, completion: completion)
    }
    
    static func presentViewController(viewControllerToPresent: UIViewController, animated: Bool, modalPresentationStyle: UIModalPresentationStyle, withDismissButton: Bool, completion: () -> Void) {
        presentViewController(viewControllerToPresent, animated: animated, modalPresentationStyle: modalPresentationStyle, withDismissButton: withDismissButton, completion: completion, dismissAction: nil)
        
    }
    
    static func presentViewController(viewControllerToPresent: UIViewController, animated: Bool, modalPresentationStyle: UIModalPresentationStyle, withDismissButton: Bool, completion: () -> Void, dismissAction: (() -> Void)?) {
        
        var canPresent = viewControllerToPresent.isKindOfClass(UINavigationController) || viewControllerToPresent.isKindOfClass(UISplitViewController)
        
        if canPresent {
            if withDismissButton {
                //modifyViewControllerLeftItem2Close
            }
            
            viewControllerToPresent.modalPresentationStyle = modalPresentationStyle
            
            //topviewcontroller
            
            
            
            
        }
        if (canPresent) {
            if (withDismissButton) {
                self.modifyViewControllerLeftItem2Close(viewControllerToPresent, withDimissAction: dismissAction!)
            }
            
            viewControllerToPresent.modalPresentationStyle = modalPresentationStyle;
            
            let topViewController = self.topViewController()
            
            if (ZEPP.IPAD_REGULAR && topViewController.navigationController!.splitViewController != nil) {
                topViewController.navigationController?.splitViewController?.presentViewController(viewControllerToPresent, animated: animated, completion: completion)
            }else{
                if (topViewController.navigationController != nil) {
                    topViewController.navigationController?.presentViewController(viewControllerToPresent, animated: animated, completion: completion)
                } else {
                    topViewController.presentViewController(viewControllerToPresent, animated: animated, completion: completion)
                }
            }
        }else{
            
        }
        
    }
    
    
    static func modifyViewControllerLeftItem2Close(viewController: UIViewController, withDimissAction: () -> Void) {
        if viewController.isKindOfClass(UINavigationController) {
            
        }
    }
    
    static func modifyNavigationViewControllerLeftItem2Close(nav: UINavigationController, withDismissAction: () -> Bool) {
        var array: NSMutableArray
        
        if let items = nav.visibleViewController?.navigationItem.leftBarButtonItems {
            array = NSMutableArray(array: items)
        }else {
            array = NSMutableArray()
        }
        
        var needAddDismissButton = true
        
        for obj in array {
            if obj.isKindOfClass(ZPDismissBarButtonItem) {
                needAddDismissButton = false
                break
            }
        }
        if (needAddDismissButton) {
            let item = ZPDismissBarButtonItem(image: UIImage(named: "common_topnav_x_white"), style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            
            item.setDismissActionBlock(withDismissAction)
            array.insertObject(item, atIndex: 0)
            nav.visibleViewController?.navigationItem.leftBarButtonItems = array as NSArray as? [UIBarButtonItem]
        }
    }
}