//
//  AccountRegisterViewController.swift
//  SportDemo
//
//  Created by Binea Xu on 8/15/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class AccountRegisterViewController: BaseViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var mTextEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTextEmail.delegate = self
        
    }
    @IBAction func signUp() {
        hideKeyBoard()
        let strEmail = mTextEmail.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if !NSStringValidation.isValidEmail(strEmail){
            print("is not valid email")
            UIGlobal.showErrorMessage(NSLocalizedString("str_common_invalid_email", comment: "str_common_invalid_email"))
            return
        }
        
        UIGlobal.showLoadingWithMessage(NSLocalizedString("str_waiting", comment: "str_waiting"))
        
        let time: NSTimeInterval = 2.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(time * Double(NSEC_PER_SEC)))
        
        dispatch_after(delay, dispatch_get_main_queue()) {
            UIGlobal.hideLoading()
            self.performSegueWithIdentifier("ZPAccountRegisterProfileSegue", sender: self)
        }
        
//        let viewController = BaseTableViewController.instanceNavigationControllerFromStoryboard("Account", viewControllerName: "ZPAccountRegisterProfileViewController")
//        presentViewController(viewController, animated: true, completion: nil)
        //todo
    }
    @IBAction func loginWithFacebook() {
    }
    
    
    @IBAction func loginWithWechat() {
    }
    
    func hideKeyBoard(){
        mTextEmail.resignFirstResponder()
    }
    
    @IBAction func tapToHideKeyboard(sender: AnyObject) {
        hideKeyBoard()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        signUp()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ZPAccountRegisterProfileSegue" {
            
        }
    }
}
