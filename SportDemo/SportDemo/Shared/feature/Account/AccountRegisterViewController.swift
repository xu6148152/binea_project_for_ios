//
//  AccountRegisterViewController.swift
//  SportDemo
//
//  Created by Binea Xu on 8/15/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class AccountRegisterViewController: BaseViewController {
    
    
    @IBOutlet weak var mTextEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func signUp() {
        hideKeyBoard()
        
    }
    @IBAction func loginWithFacebook() {
    }
    
    
    @IBAction func loginWithWechat() {
    }
    
    func hideKeyBoard(){
        mTextEmail.resignFirstResponder()
    }
}
