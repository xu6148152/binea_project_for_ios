//
//  ZPDialogPopoverView.swift
//  SportDemo
//
//  Created by Binea Xu on 9/20/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import Foundation
import TTTAttributedLabel
import PureLayout

enum ZPPopoverButtonType{
    case ZPPopoverButtonNone, ZPPopoverButtonNormal, ZPPopoverButtonNegative
}

class ZPDialogPopoverView: ZPPopoverView{
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var message: TTTAttributedLabel!
    
    @IBOutlet weak var actionButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonHeightConstraint: NSLayoutConstraint!
    
    var actionBlock: (() -> Void)?
    var cancelBlock: (() -> Void)?
    
    @IBOutlet weak var containerView: UIView!
    static func _viewWithTitle(title: String, message: String, actionTitle: String, actionBlock: (()->Void), cancelTitle: String,
        cancelBlock: (()->Void), buttonType: ZPPopoverButtonType) -> ZPDialogPopoverView{
            let view = ZPDialogPopoverView().initFromNib() as! ZPDialogPopoverView
            view.autoSetDimension(ALDimension.Width, toSize: 290)
            view.title.text = title.uppercaseString
            view.message.textInsets = UIEdgeInsetsMake(15, 0, 0, 0)
            view.message.text = message
            
            if buttonType == ZPPopoverButtonType.ZPPopoverButtonNone {
                
                view.actionButtonHeightConstraint.constant = 0;
                view.cancelButtonHeightConstraint.constant = 0;
                view.actionButton.hidden = true;
                view.cancelButton.hidden = true;
                view.autoSetDimension(ALDimension.Height, toSize: 370)
            }else {
                if (!actionTitle.isEmpty) {
                    view.actionButton.setTitle(actionTitle.uppercaseString, forState: UIControlState.Normal)
                    view.actionButton.backgroundColor = buttonType == ZPPopoverButtonType.ZPPopoverButtonNormal ? UIGlobal.UIColorFromARGB(0x3C464D) : UIGlobal.UIColorFromARGB(0xFF2829)
                    
                    view.actionBlock = actionBlock;
                } else {
                    view.actionButton.hidden = true;
                    view.actionButtonHeightConstraint.constant = 0;
                }
                
                if (!cancelTitle.isEmpty) {
                    view.cancelButton.setTitle(cancelTitle.uppercaseString, forState: UIControlState.Normal)
                    view.cancelButton.backgroundColor = buttonType == ZPPopoverButtonType.ZPPopoverButtonNormal ? UIGlobal.UIColorFromARGB(0x30383D) : UIGlobal.UIColorFromARGB(0xD61111)
                    view.cancelBlock = cancelBlock;
                } else {
                    view.cancelButton.hidden = true;
                    view.cancelButtonHeightConstraint.constant = 0;
                }
            }

            
            
            return view
    }
    
    static func showDialog(title: String,
        message: String,
        customView: UIView?,
        actionTitle: String,
        actionBlock: () -> Void,
        cancelTitle: String,
        cancelBlock: () -> Void,
        buttonType: ZPPopoverButtonType) {
            
        let view = _viewWithTitle(title, message: message, actionTitle: actionTitle, actionBlock: actionBlock, cancelTitle: cancelTitle, cancelBlock: cancelBlock, buttonType: buttonType)
            view.imageView.removeFromSuperview()
            if customView != nil {
                view.containerView.addSubview(customView!)
            }
        view.show()
    }
    
}

