//
//  BouncerBehavior.swift
//  Bouncer
//
//  Created by Binea Xu on 7/18/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class BouncerBehavior: UIDynamicBehavior {
    
    let gravity = UIGravityBehavior()
    
    lazy var collider : UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
        }()
    
    lazy var blockBehavior : UIDynamicItemBehavior = {
        let lazilyCreatedBlockBehavior = UIDynamicItemBehavior()
        lazilyCreatedBlockBehavior.allowsRotation = false
        lazilyCreatedBlockBehavior.elasticity = 0.85
        lazilyCreatedBlockBehavior.friction = 0
        lazilyCreatedBlockBehavior.resistance = 0
        
        return lazilyCreatedBlockBehavior
        }()
    
    override init(){
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(blockBehavior)
    }
    
    func addBlock(view : UIView){
        dynamicAnimator?.referenceView?.addSubview(view)
        gravity.addItem(view)
        collider.addItem(view)
        blockBehavior.addItem(view)
    }
    
    func removeBlock(view : UIView){
        gravity.removeItem(view)
        collider.removeItem(view)
        blockBehavior.removeItem(view)
    }
    
    func addBarrier(path: UIBezierPath, named name: String){
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
}
