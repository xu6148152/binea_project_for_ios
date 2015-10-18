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
    var hiddenTopViewDefaultPosition: CGFloat!
    var xiaoyunOriginX: CGFloat!
    var middleImageViewHasBeenEnlarged = true
    
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
        hiddenTopViewDefaultPosition = -(hiddenTopView.frame.height / 2)
//        topLayoutConstraintOfHiddenTopView.constant = hiddenTopViewDefaultPosition
        rightDistanceOfXiaoyun.constant = 60
        xiaoyunOriginX = xiaoyunView.frame.origin.x
        makeDayunRolling()
        // Do any additional setup after loading the view, typically from a nib.
//        let button = NSBundle.mainBundle().loadNibNamed("RoundButton", owner: self, options: nil).first as! UIButton
//        button.center = self.view.center
//        self.view.addSubview(button)
    }
    
    func makeDayunRolling() {
        leftDistanceOfDayun.constant -= 30
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.dayunView.layoutIfNeeded()
            }) { (success) -> Void in
                if success {
                    self.leftDistanceOfDayun.constant += 30
                    UIView.animateWithDuration(0.8, delay: 0.5, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                        self.dayunView.layoutIfNeeded()
                        }, completion: { (success) -> Void in
                            if success {
                                self.makeDayunRolling()
                            }
                    })
                }
        }
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
            middleImageViewHasBeenEnlarged = true
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    recongnizer.view?.frame.origin.y = self.mainViewOriginY
                
                    //make animated views move
                    self.hiddenTopView.frame.origin.y = self.hiddenTopViewDefaultPosition
                }, completion: { (success) -> Void in
                    if success {
                        self.topLayoutConstraintOfMainView.constant = self.mainViewTopSpaceLayoutConstraintValue
                    }
            })
            return
        }
        let y = panGesture.translationInView(self.view).y
        topLayoutConstraintOfMainView.constant = mainViewTopSpaceLayoutConstraintValue + y
        
        //move xiaoyun when pull
        let xiaoyunDistance = 60 - y*0.5
        if xiaoyunDistance > -48 {
            rightDistanceOfXiaoyun.constant = xiaoyunDistance
        }else {
            //slow down xiaoyun's speed when it needs
            rightDistanceOfXiaoyun.constant = -sqrt(-xiaoyunDistance - 47) - 47
        }
        
        //move HiddenTopView when pull
        let distance = 0.3 * y + hiddenTopViewDefaultPosition
        if distance < 1 {
            topLayoutConstraintOfHiddenTopView.constant = distance
        }else {
            //slow down HiddenTopView's speed when it needs
            topLayoutConstraintOfHiddenTopView.constant = sqrt(distance)
        }
        
        if mainViewTopSpaceLayoutConstraintValue + y > hiddenTopView.frame.height * 1.2 {
            if middleImageViewHasBeenEnlarged {
                enlargeMiddleImageView()
                middleImageViewHasBeenEnlarged = false
            }
        }
    }
    
    //enlarge middle image
    func enlargeMiddleImageView() {
        UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.hiddenBannerView.transform = CGAffineTransformMakeScale(1.1, 1.1)
            }) { (success) -> Void in
                if success {
                    return
                }
        }
    }

}

