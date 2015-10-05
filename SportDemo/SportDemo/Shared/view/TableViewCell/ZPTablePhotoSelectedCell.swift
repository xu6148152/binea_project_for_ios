//
//  ZPTablePhotoSelectedCell.swift
//  SportDemo
//
//  Created by Binea Xu on 8/29/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit
import SDWebImage

class ZPTablePhotoSelectedCell: UITableViewCell,  UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var btnAvatar: UIButton!
    
    @IBOutlet weak var labelValue: UILabel!
    
    @IBOutlet weak var labelPrompt: UILabel!
    
    private var parentViewController: UIViewController?
    
    func setCurrentViewController(viewController: UIViewController){
        parentViewController = viewController
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.labelPrompt.text = NSLocalizedString("str_my_account_change_icon", comment: "str_my_account_change_icon")
        setBtnAvatarBackground(nil)
    }
    
    func setBtnAvatarBackground(url: NSURL?){
        self.btnAvatar.sd_setBackgroundImageWithURL(url, forState: UIControlState.Normal, placeholderImage: UIImage(named: "common_defaultportrait_128"))
        
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
        var sourceType: UIImagePickerControllerSourceType
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        
        if buttonIndex == 1{
            sourceType = .PhotoLibrary
//            dispatch_after(delayTime, dispatch_get_main_queue()) {
//                
//            }
        }else if buttonIndex == 2{
            sourceType = .Camera
//            dispatch_after(delayTime, dispatch_get_main_queue()) {
//                
//            }
        }else{
            return
        }
        
        // configure image picker controller
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        
        // present the image picker controller
        parentViewController?.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
//    func takePhotoWithSourceType(source: NSNumber){
//        let sourceType = UIImagePickerControllerSourceType(rawValue: source.integerValue)
//        UIGlobal.showImagePickerControllerInViewController(ZPControl.topViewController(), addtionalConstruction: { (picker) -> Void in
//            picker.sourceType = sourceType!
//            }, didFinishPickingMedia: { (info) -> Void in
//                if let image = info[UIImagePickerControllerEditedImage] {
//                    
//                }
//            }, didCancel: nil)
//        
//    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        // fire completion handler
//        setBtnAvatarBackground(info[UIImagePickerControllerEditedImage])
        self.btnAvatar.setBackgroundImage(info[UIImagePickerControllerEditedImage] as? UIImage, forState: UIControlState.Normal)
        // dismiss the image picker
        dismissImagePicker()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissImagePicker()
    }
    
    func dismissImagePicker() {
        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
