//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Binea Xu on 6/7/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
        }
    }
    
    struct Constants{
        static let happinessGestureScale : CGFloat = 4
    }
    
    @IBAction func changeHappness(sender: UIPanGestureRecognizer) {
        switch sender.state{
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(faceView)
            let happinessChaned = Int(translation.y / Constants.happinessGestureScale)
            if happinessChaned != 0{
                smileness += Double(happinessChaned)
                sender.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
            
        }
    }
    
    var smileness:Double = 0{//0 very sad 100 estatic
        didSet{
            smileness = max(min(smileness, 100), 0)
            title = "\(smileness)"
            faceView?.setNeedsDisplay()
        }
    }

    func faceViewForDataSource(sender:FaceView) ->Double?{
        return (smileness - 50) / 50
    }
}
