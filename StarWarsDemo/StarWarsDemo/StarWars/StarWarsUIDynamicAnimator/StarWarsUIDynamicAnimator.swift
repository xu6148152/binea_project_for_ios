//
//  StarWarsUIDynamicAnimator.swift
//  StarWarsDemo
//
//  Created by Binea Xu on 11/6/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit

public class StarWarsUIDynamicAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var duration: NSTimeInterval = 2
    public var spriteWidth: CGFloat = 20
    
    var transitionContext: UIViewControllerContextTransitioning!
    
    // This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
    // synchronize with the main animation.
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    var animator: UIDynamicAnimator!
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()!
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
        
        container.addSubview(toView)
        container.sendSubviewToBack(toView)
        
        var snapshots: [UIView] = [];
        let size = fromView.frame.size
        
        func randomFloatBetween(smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
            let diff = bigNumber - smallNumber
            return CGFloat(arc4random()) / 100.0 % diff + smallNumber
        }
        
        let fromViewSnapshot = fromView.snapshotViewAfterScreenUpdates(false)
        
        let width = spriteWidth
        let height = width
        
        animator = UIDynamicAnimator(referenceView: container)
        
        for x in CGFloat(0).stride(through: size.width, by: width) {
            for y in CGFloat(0).stride(through: size.height, by: size.height) {
                let snapshotRegion = CGRect(x: x, y: y, width: width, height: height)
                let snapshot = fromViewSnapshot.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
                
                container.addSubview(snapshot)
                snapshot.frame = snapshotRegion
                snapshots.append(snapshot)
                
                let push = UIPushBehavior(items: [snapshot], mode: .Instantaneous)
                push.pushDirection = CGVector(dx: randomFloatBetween(-0.15, and: 0.15), dy: randomFloatBetween(-0.15, and: 0))
                push.active = true
                animator.addBehavior(push)
            }
        }
        let gravity = UIGravityBehavior(items: snapshots)
        animator.addBehavior(gravity)
        
        fromView.removeFromSuperview()
        NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: "completeTransition", userInfo: nil, repeats: false)
        self.transitionContext = transitionContext
        
    }
    
    func completeTransition() {
        self.transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
}
