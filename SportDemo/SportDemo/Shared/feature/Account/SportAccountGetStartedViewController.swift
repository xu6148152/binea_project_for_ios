//
//  SportAccountGetStartedViewController.swift
//  SportDemo
//
//  Created by Binea Xu on 8/2/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class SportAccountGetStartedViewController: UIViewController {

    
    static func instanceFromStoryboard() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        
        return storyBoard.instantiateViewControllerWithIdentifier("SportAccountGetStartedViewController") as! UIViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
