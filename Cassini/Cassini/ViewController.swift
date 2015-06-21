//
//  ViewController.swift
//  Cassini
//
//  Created by Binea Xu on 6/21/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ivc = segue.destinationViewController as? ImageViewController{
            if let identifier = segue.identifier{
                switch identifier{
                    case "earth":
                        ivc.imageURL = DemoURL.NASA.Earth
                        ivc.title = identifier
                    case "cassini":
                        ivc.imageURL = DemoURL.NASA.Cassini
                        ivc.title = identifier
                    case "saturn":
                        ivc.title = identifier
                        ivc.imageURL = DemoURL.NASA.Saturn
                    
                default: break
                    
                }
            }
        }
    }


}

