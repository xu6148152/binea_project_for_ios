//
//  ViewController.swift
//  SlidingMenuLikeQQ
//
//  Created by Binea Xu on 9/14/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    
    
    
    
    let FULL_DISTANCE: CGFloat = 0.78
    let PROPORTION: CGFloat = 0.77
    
    var proportionOfLeftView: CGFloat = 1
    var distanceOfLeftView: CGFloat = 50
    var centerOfLeftViewAtBeginning: CGPoint!
    var distance: CGFloat = 0
    
    //shadow
    var blackCover: UIView!
    
    //mainview
    var mainView: UIView!
    
    var mainTabBarController: MainTabBarController!
    
    var tapGesture: UITapGestureRecognizer!
    
    var homeNavigationController: UINavigationController!
    
    var homeViewController: HomeViewController!
    
    var leftViewController: LeftViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "back"))
        imageView.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(imageView)
        
        leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
        
        if Common.screenWidth > 320 {
            proportionOfLeftView = Common.screenWidth / 320
            distanceOfLeftView = (Common.screenWidth - 320) * FULL_DISTANCE / 2
        }
        
        leftViewController.view.center = CGPointMake(leftViewController.view.center.x - 50, leftViewController.view.center.y)
        leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)
        
        centerOfLeftViewAtBeginning = leftViewController.view.center
        self.view.addSubview(leftViewController.view)
        
        blackCover = UIView(frame: CGRectOffset(self.view.frame, 0, 0))
        blackCover.backgroundColor = UIColor.blackColor()
        self.view.addSubview(blackCover)
        
        mainView = UIView(frame: self.view.frame)
        let nibContents = NSBundle.mainBundle().loadNibNamed("MainTabBarController", owner: nil, options: nil)

        mainTabBarController = nibContents.first as! MainTabBarController
        
        let tabBarView = mainTabBarController.view
        mainView.addSubview(tabBarView)
        homeNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeNavigationController") as! UINavigationController
        
        homeViewController = homeNavigationController.viewControllers.first as! HomeViewController
        
        tabBarView.addSubview(homeViewController.navigationController!.view)
        tabBarView.addSubview(homeViewController.view)
        
        tabBarView.bringSubviewToFront(mainTabBarController.tabBar)
        
        self.view.addSubview(mainView)
        
        homeViewController.navigationItem.leftBarButtonItem?.action = Selector("showLeft")
        homeViewController.navigationItem.rightBarButtonItem?.action = Selector("showRight")
        
        let panGesture = homeViewController.panGesture
        
        panGesture.addTarget(self, action: Selector("pan:"))
        mainView.addGestureRecognizer(panGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: "showHome")
        
    }
    
    func pan(recoginizer: UIPanGestureRecognizer) {
        let x = recoginizer.translationInView(self.view).x
        let trueDistance = distance + x
        let trueProportion = trueDistance / (Common.screenWidth * FULL_DISTANCE)
        
        if recoginizer.state == UIGestureRecognizerState.Ended {
            
            if trueDistance > Common.screenWidth * (PROPORTION / 3) {
                showLeft()
            }else if trueDistance < Common.screenWidth * (-PROPORTION / 3) {
                showHome()
            } else {
                showRight()
            }
            
            return
        }
        
        var proportion: CGFloat = recoginizer.view!.frame.origin.x >= 0 ? -1 : 1
        proportion *= trueDistance / Common.screenWidth
        proportion *= 1 - PROPORTION
        proportion /= FULL_DISTANCE + PROPORTION / 2 - 0.5
        proportion += 1
        if proportion <= PROPORTION {
            return
        }
        
        blackCover.alpha = (proportion - PROPORTION) / (1 - PROPORTION)
        
        recoginizer.view!.center = CGPointMake(self.view.center.x + trueDistance, self.view.center.y)
        recoginizer.view!.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion)
        
        let pro = 0.8 + (proportionOfLeftView - 0.8) * trueProportion
        leftViewController.view.center = CGPointMake(centerOfLeftViewAtBeginning.x + distanceOfLeftView * trueProportion, centerOfLeftViewAtBeginning.y - (proportionOfLeftView - 1) * leftViewController.view.frame.height * trueProportion / 2)
        leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, pro, pro)
    }
    
    func showLeft() {
        mainView.addGestureRecognizer(tapGesture)
        distance = self.view.center.x * (FULL_DISTANCE * 2 + PROPORTION - 1)
        doTheAnimation(self.PROPORTION, oriention: ORIENTION.LEFT)
        homeNavigationController.popToRootViewControllerAnimated(true)
    }
    
    func showRight() {
        mainView.removeGestureRecognizer(tapGesture)
        distance = 0
        doTheAnimation(1, oriention: ORIENTION.HOME)
    }
    
    func showHome() {
        mainView.addGestureRecognizer(tapGesture)
        distance = self.view.center.x * (FULL_DISTANCE * 2 + PROPORTION - 1)
        doTheAnimation(self.PROPORTION, oriention: ORIENTION.RIGHT)
    }
    
    func doTheAnimation(proprotion: CGFloat, oriention: ORIENTION) {
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.mainView.center = CGPointMake(self.view.center.x + self.distance, self.view.center.y)
            
            self.mainView.transform = CGAffineTransformScale(CGAffineTransformIdentity, proprotion, proprotion)
            
            if oriention == ORIENTION.LEFT {
                self.leftViewController.view.center = CGPointMake(self.centerOfLeftViewAtBeginning.x + self.distanceOfLeftView, self.leftViewController.view.center.y)
                
                self.leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.proportionOfLeftView, self.proportionOfLeftView)
                
            }
            
            self.blackCover.alpha = oriention == ORIENTION.HOME ? 1 : 0
            
            self.leftViewController.view.alpha = oriention == ORIENTION.RIGHT ? 0 : 1
            }, completion: nil)
        
        
    }
    
    enum ORIENTION {
        case LEFT
        case HOME
        case RIGHT
        
    }
}