//
//  ZPTablePhotoSelectedCell.swift
//  SportDemo
//
//  Created by Binea Xu on 8/29/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ZPTablePhotoSelectedCell: ZPTableBaseCell,  UIActionSheetDelegate{

    @IBOutlet weak var btnAvatar: UIButton!
    
    @IBOutlet weak var labelValue: UILabel!
    
    @IBOutlet weak var labelPrompt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.labelPrompt.text = NSLocalizedString("str_my_account_change_icon", comment: "str_my_account_change_icon")
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func profilePhotoDidClick(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue()) {
            
            let actionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: NSStringLocalization.StringLocalization("str_cancel"), destructiveButtonTitle: nil, otherButtonTitles: NSStringLocalization.StringLocalization("str_my_account_photos"))
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                actionSheet.addButtonWithTitle(NSStringLocalization.StringLocalization("str_my_account_camera"))
            }
            
            actionSheet.showFromTabBar(((UIApplication.sharedApplication().keyWindow?.rootViewController as? UITabBarController)?.tabBar)!)
            
        }
    }
    
    static func rowHeight() -> CGFloat{
        return 110.0
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        actionSheet.dismissWithClickedButtonIndex(buttonIndex, animated: true)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        
        if buttonIndex == 0{
            
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                
            }
        }else{
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                
            }
        }
    }
    
    func takePhotoWithSourceType(source: NSNumber){
        UIImagePickerControllerSourceType(rawValue: source.integerValue)
        
        
    }
}
