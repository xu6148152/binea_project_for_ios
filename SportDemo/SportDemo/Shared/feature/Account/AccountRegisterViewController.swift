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
        performSegueWithIdentifier("ZPAccountRegisterProfileSegue", sender: self)
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
