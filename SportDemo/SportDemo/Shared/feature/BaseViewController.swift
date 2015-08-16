//
//  BaseViewController.swift
//  SportDemo
//
//  Created by Binea Xu on 8/8/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    static func instanceFromStoryboard(storyBoardName: String, viewControllerName: String)->UIViewController{
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(viewControllerName) as! UIViewController
    }
    
    static func instanceNavigationControllerFromStoryboard(storyBoardName: String, viewControllerName: String) -> UINavigationController{
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(viewControllerName) as! UINavigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func presentViewController(viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?){
        viewControllerToPresent.transitioningDelegate = self
        super.presentViewController(viewControllerToPresent, animated: animated, completion: completion)
    }


}

extension UIViewController {
    func closeAnimated() {
        if self.navigationController != nil && self.navigationController?.viewControllers.count > 1 {
            self.navigationController?.popViewControllerAnimated(true)
        } else if self.presentingViewController != nil {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
