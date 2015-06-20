//
//  ViewController.swift
//  AutoLayoutDemo
//
//  Created by Binea Xu on 6/20/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    var secure : Bool = false{
        didSet{
            updateUI()
        }
    }
    private func updateUI(){
        passwordField.secureTextEntry = true
        passwordLabel.text = secure ? "Secure Password" : "password"
    }
    @IBAction func toggleSecure(sender: AnyObject) {
        secure = !secure
    }
}

