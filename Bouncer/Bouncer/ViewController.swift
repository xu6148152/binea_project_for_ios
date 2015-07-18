//
//  ViewController.swift
//  Bouncer
//
//  Created by Binea Xu on 7/18/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let bouncer = BouncerBehavior()
    lazy var animator: UIDynamicAnimator = {
       UIDynamicAnimator(referenceView: self.view)
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.addBehavior(bouncer)
        
    }
    
    var redBlock: UIView?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if redBlock == nil{
            redBlock = addBlock()
            redBlock?.backgroundColor = UIColor.redColor()
            bouncer.addBlock(redBlock!)
        }
        
        let motionManager = AppDelegate.Motion.motionManager
        if motionManager.accelerometerAvailable{
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()){
                (data, error) -> Void
                in
                self.bouncer.gravity.gravityDirection = CGVector(dx: data.acceleration.x, dy: data.acceleration.y)
            }
        }

    }
    
    override func viewDidDisappear(animated: Bool) {
        AppDelegate.Motion.motionManager.stopAccelerometerUpdates()
    }

    struct Constans {
        static let blockSize = CGSize(width: 40, height: 40)
    }
    
    func addBlock() -> UIView{
        let block = UIView(frame: CGRect(origin: CGPoint.zeroPoint, size: Constans.blockSize))
        block.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(block)
        
        return block
        
    }

}

