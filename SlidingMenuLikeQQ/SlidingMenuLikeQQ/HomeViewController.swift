//
//  ViewController.swift
//  SlidingMenuLikeQQ
//
//  Created by Binea Xu on 9/14/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    var titleOfOtherPages = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmentView = UISegmentedControl(items: ["消息", "电话"])
        segmentView.selectedSegmentIndex = 0
        segmentView.setWidth(60, forSegmentAtIndex: 0)
        segmentView.setWidth(60, forSegmentAtIndex: 1)
        self.navigationItem.titleView = segmentView
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOtherPages" {
            if let a = segue.destinationViewController as? OtherPageViewController {
                
            }
        }
    }
}

