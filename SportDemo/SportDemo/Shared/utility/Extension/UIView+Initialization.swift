//
//  UIView+Initialization.swift
//  SportDemo
//
//  Created by Binea Xu on 9/26/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import Foundation

extension UIView{
    func initFromNib() -> UIView{
        return NSBundle.mainBundle().loadNibNamed(NSStringFromClass(self.classForCoder), owner: nil, options: nil)[0] as! UIView
    }
}