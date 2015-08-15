//
//  ZPTextField.swift
//  SportDemo
//
//  Created by Binea Xu on 8/15/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ZPTextField: UITextField {
    var placeHolderColor = UIColor()
    
    convenience init(){
        self.init()
        commitDefault()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commitDefault() {
        self.placeHolderColor = UIGlobal.UIColorFromARGB(0x555555);
        self.textColor = UIGlobal.ZEPPGREENCOLOR
    }

}
