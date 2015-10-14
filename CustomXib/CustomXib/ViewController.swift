//
//  ViewController.swift
//  CustomXib
//
//  Created by Binea Xu on 10/13/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var mainViewTopSpaceLayoutConstraintValue: CGFloat!
    var mainViewOriginY: CGFloat!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var topLayoutConstraintOfMainView: NSLayoutConstraint!
    
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    
    @IBOutlet weak var hiddenTopView: UIView!
    
    @IBOutlet weak var topLayoutConstraintOfHiddenTopView: NSLayoutConstraint!
    
    @IBOutlet weak var dayunView: UIView!
    
    @IBOutlet weak var xiaoyunView: UIView!
    
    @IBOutlet weak var hiddenBannerView: UIView!
    
    @IBOutlet weak var leftDistanceOfDayun: NSLayoutConstraint!
    
    @IBOutlet weak var rightDistanceOfXiaoyun: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewTopSpaceLayoutConstraintValue = topLayoutConstraintOfMainView.constant
        mainViewOriginY = mainView.frame.origin.y
        panGesture.addTarget(self, action: "pan:")

        // Do any additional setup after loading the view, typically from a nib.
//        let button = NSBundle.mainBundle().loadNibNamed("RoundButton", owner: self, options: nil).first as! UIButton
//        button.center = self.view.center
//        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func centerButtonBeTapped(sender: AnyObject) {
        print("centerButtonBeTapped")
    }
    
    func pan(recongnizer: UIPanGestureRecognizer) {
        if panGesture.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    recongnizer.view?.frame.origin.y = self.mainViewOriginY
                }, completion: { (success) -> Void in
                    if success {
                        self.topLayoutConstraintOfMainView.constant = self.mainViewTopSpaceLayoutConstraintValue
                    }
            })
            return
        }
        let y = panGesture.translationInView(self.view).y
        topLayoutConstraintOfMainView.constant = mainViewTopSpaceLayoutConstraintValue + y
    }

}

