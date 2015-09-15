//
//  OtherPageViewController.swift
//  SlidingMenuLikeQQ
//
//  Created by Binea Xu on 9/14/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit

class OtherPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let backButton = UIBarButtonItem(title: "<返回", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        self.navigationItem.leftBarButtonItem = backButton
        
        let gesture = UIPanGestureRecognizer(target: self, action: "goBack")
        self.view.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
        Common.rootViewController.mainTabBarController.tabBar.hidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
