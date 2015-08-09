//
//  BaseViewController.swift
//  SportDemo
//
//  Created by Binea Xu on 8/8/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
