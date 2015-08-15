//
//  ZPTextField.swift
//  SportDemo
//
//  Created by Binea Xu on 8/15/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ZPTextField: UITextField {

    var placeHolderColor : UIColor{
        set{
            var placeholder = NSAttributedString(string: "Some", attributes: [NSForegroundColorAttributeName : newValue])
            self.attributedPlaceholder = placeholder;
        }
        
        get{
            return self.placeHolderColor
        }
    }
    
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
