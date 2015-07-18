//
//  ViewController.swift
//  Trax
//
//  Created by Binea Xu on 7/18/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelete = UIApplication.sharedApplication()
        
        center.addObserverForName(GPXURL.notification, object: appDelete, queue: queue){
            notification in
            if let url = notification?.userInfo?[GPXURL.key] as? NSURL{
                self.textView.text = "received \(url)"
            }
        }
    }


}

