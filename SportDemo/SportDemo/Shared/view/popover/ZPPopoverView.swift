//
//  ZPPopoverView.swift
//  SportDemo
//
//  Created by Binea Xu on 9/20/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit
import KLCPopup

class ZPPopoverView: UIView {
    func show() {
        hideAll()
        
    }
    
    func showWithDuration(duration: NSTimeInterval) {
        let pop = KLCPopup(contentView: self, showType: KLCPopupShowType.BounceIn, dismissType: KLCPopupDismissType.BounceOut, maskType: KLCPopupMaskType.Dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        pop.showWithDuration(duration)
    }
    
    func hideAll() {
        KLCPopup.dismissAllPopups()
    }
    
    func hide() {
        dismissPresentingPopup()
    }
    
    
    
}