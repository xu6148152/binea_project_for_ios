//
//  SportAccountGetStartedViewController.swift
//  SportDemo
//
//  Created by Binea Xu on 8/2/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class SportAccountGetStartedViewController: BaseViewController {

    @IBOutlet weak var btnSignUpBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var app_name: UILabel!
    var isResetPassword = false
    var isLoaded = false
    
    static func instanceFromStoryboard() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        
        return storyBoard.instantiateViewControllerWithIdentifier("SportAccountGetStartedViewController") 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let notification = NSNotificationCenter.defaultCenter()
        notification.addObserver(self, selector: "resetPasswordNotification", name: "resetPasswordNotification", object: nil)
        app_name.text = app_name.text?.uppercaseString
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        if !isLoaded {
//            isLoaded = true
//            UIView.animateWithDuration(0.8, delay: 0.2, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
//                self.btnSignUpBottomConstraint.constant = 0
//                self.view.layoutIfNeeded()
//            }, completion: nil)
//        }
//        
//        if isResetPassword{
//            isResetPassword = false
//            
//        }
    }
    
    func resetPasswordNotification(){
        isResetPassword = false
    }

    @IBAction func signIn() {
    }
    
    @IBAction func signUp(){
        let uinavigationController = SportAccountGetStartedViewController.instanceNavigationControllerFromStoryboard("Account", viewControllerName: "ZPAccountRegisterViewControllerNav")

        presentViewController(uinavigationController, animated: true, completion: nil)

        
    }
    
}
