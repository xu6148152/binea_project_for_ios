//
//  DropitBehavior.swift
//  Dropit
//
//  Created by Binea Xu on 6/27/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class DropitBehavior: UIDynamicBehavior {
    
    let gravity = UIGravityBehavior()
    
    lazy var collider : UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
    }()
    
    lazy var dropBehavior : UIDynamicItemBehavior = {
        let lazilyCreatedDropBehavior = UIDynamicItemBehavior()
        lazilyCreatedDropBehavior.allowsRotation = false
        lazilyCreatedDropBehavior.elasticity = 0.75
        
        return lazilyCreatedDropBehavior
    }()
    
    override init(){
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }
    
    func addDrop(view : UIView){
        dynamicAnimator?.referenceView?.addSubview(view)
        gravity.addItem(view)
        collider.addItem(view)
        dropBehavior.addItem(view)
    }
    
    func removeDrop(view : UIView){
        gravity.removeItem(view)
        collider.removeItem(view)
        dropBehavior.removeItem(view)
    }
    
    func addBarrier(path: UIBezierPath, named name: String){
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
   
}
