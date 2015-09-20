//
//  ZPDialogPopoverView.swift
//  SportDemo
//
//  Created by Binea Xu on 9/20/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import Foundation
import TTTAttributedLabel

enum ZPPopoverButtonType{
    case ZPPopoverButtonNone, ZPPopoverButtonNormal, ZPPopoverButtonNegative
}

class ZPDialogPopoverView: ZPPopoverView{
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var message: TTTAttributedLabel!
    
    static func showDialog(title: String,
        message: String,
        customView: UIView,
        actionTitle: String,
        actionBlock: (),
        cancelTitle: String,
        cancelBlock: (),
        buttonType: ZPPopoverButtonType) {
        
    }
    
}

