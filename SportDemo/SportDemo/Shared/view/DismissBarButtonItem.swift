//
//  DismissBarButtonItem.swift
//  SportDemo
//
//  Created by Binea Xu on 8/8/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class DismissBarButtonItem: UIBarButtonItem{
    override func awakeFromNib() {
        super.awakeFromNib()
        
        target = self
        action = "close"
        
    }
    
    func close(){
        Utility.getTopmostViewController().closeAnimated()
    }
}
