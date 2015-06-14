//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by Binea Xu on 6/14/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit
class DiagnosedHappinessViewController : HappinessViewController, UIPopoverPresentationControllerDelegate{
    
    override var smileness : Double{
        didSet{
            diagnoseHistory += [smileness]
        }
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var diagnoseHistory : [Double]{
        get{
            return defaults.objectForKey(History.defaultsKey) as? [Double] ?? []
        }
        
        set{
            defaults.setObject(newValue, forKey: History.defaultsKey)
        }
    }

    
    private struct History{
        static let SegueIdentifier = "diagnosed history"
        static let defaultsKey = "Psychologist.History"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier{
                case History.SegueIdentifier:
                    if let tvc = segue.destinationViewController as? DiagnosedHistoryViewController{
                        if let ppc = tvc.popoverPresentationController{
                            ppc.delegate = self
                        }
                        print("\(diagnoseHistory)")
                        tvc.text = "\(diagnoseHistory)"
                }
                default: break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
