//
//  ZPDismissBarButtonItem.swift
//  SportDemo
//
//  Created by Binea Xu on 9/27/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import Foundation


class ZPDismissBarButtonItem: UIBarButtonItem{
    
    typealias ZPCompleteAction = (() -> Void)?
    
    var dismissAction: ZPCompleteAction
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        config()
    }
    
    override init() {
        super.init()
        config()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func config() {
        if self.target != nil && self.action != nil {
            self.target = self
            self.action = Selector("dismissController")
        }
        
        
//        self.imageName = "common_topnav_x_white";
//        self.accessibilityLabel = @"top dismiss";
//        self.tintColor = [UIColor whiteColor];
    }
    
    func setDismissActionBlock(action: ZPCompleteAction) {
        self.dismissAction = action
    }
    
    func dismissController() {
        if dismissAction != nil {
            dismissAction!()
            self.dismissAction = nil
            
        }else {
            ZPControl.topViewController().closeAnimatedWithCompleteAction(nil)
        }
    }
}