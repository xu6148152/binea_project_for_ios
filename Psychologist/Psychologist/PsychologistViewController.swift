//
//  ViewController.swift
//  Psychologist
//
//  Created by Binea Xu on 6/14/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {
    
    @IBAction func nothing(sender: UIButton) {
        performSegueWithIdentifier("nothing", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination: AnyObject = segue.destinationViewController
        
        if let navCon = destination as? UINavigationController{
            destination = navCon.visibleViewController
        }
        
        if let hvc = destination as? HappinessViewController{
            if let identifier = segue.identifier{
                switch identifier{
                    case "sad": hvc.smileness = 0
                    case "happy": hvc.smileness = 100
                    case "nothing": hvc.smileness = 30
                    default: hvc.smileness = 50
                }
            }
        }
    }

}

