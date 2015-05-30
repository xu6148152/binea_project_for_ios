//
//  ViewController.swift
//  Calculator
//
//  Created by Binea Xu on 5/30/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var mDisplay: UILabel!

    var isFirstInputNumber: Bool = true
    
    @IBAction func displayDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("digit = \ndigit")
        if(!isFirstInputNumber){
            mDisplay.text = mDisplay.text! + digit
        }else{
            mDisplay.text = digit
            isFirstInputNumber = false
        }
    }
}

