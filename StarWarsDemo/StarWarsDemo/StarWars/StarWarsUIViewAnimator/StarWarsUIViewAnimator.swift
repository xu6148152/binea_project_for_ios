//
//  StarWarsUIViewAnimator.swift
//  StarWarsDemo
//
//  Created by Binea Xu on 10/27/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit

public class StartWarsUIViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var duration: NSTimeInterval = 2
    public var spritedWidth: CGFloat = 10
    
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!;
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
        
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)
        
        var snapshots: [UIView] = []
        let size = fromView.frame.size
        
        func randomFloatBetween(smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
            let diff = bigNumber - smallNumber
            return CGFloat(arc4random()) / 100.0 % diff + smallNumber
        }
        
        //snapshot the from view, this makes subsequent snaphots more performant
        let fromViewSnapshot = fromView.snapshotViewAfterScreenUpdates(false)
        
        let width = spritedWidth
        let height = width
        
        for x in CGFloat(0).stride(through: width, by: width) {
            for y in CGFloat(0).stride(through: size.height, by: height) {
                let snapshotRegion = CGRect(x: x, y: y, width: width, height: height)
                
                let snapshot = fromViewSnapshot.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
                
                containerView.addSubview(snapshot)
                snapshot.frame = snapshotRegion
                snapshots.append(snapshot)
            }
        }
        
        containerView.sendSubviewToBack(fromView)
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            for view in snapshots {
                
                let xOffset: CGFloat = randomFloatBetween(-200, and: 200)
                let yOffset: CGFloat = randomFloatBetween(fromView.frame.height, and: fromView.frame.height * 1.3)
                view.frame = view.frame.offsetBy(dx: xOffset, dy: yOffset)
            }
            }) { finished in
                for view in snapshots {
                    view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
}
