//
//  UIGlobal.swift
//  SportDemo
//
//  Created by Binea Xu on 8/9/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD.MBProgressHUD
import TWMessageBarManager.TWMessageBarManager
import AVFoundation
import AssetsLibrary
import BlocksKit

class UIGlobal{
    
    static let kDefaultDuration: CGFloat = 3.0
    static let kToastMininumInterval: NSTimeInterval = 3
    
    static var ZEPPGREENCOLOR: UIColor{
        get{
            return UIColorFromARGB(0xD1EE00)
        }
    }
    
    static func appWindow() -> UIWindow {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).appWindow!
    }
    
    static func UIColorFromARGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat((rgbValue & 0xff000000 > 0 ? ((Float)((rgbValue & 0xFF000000) >> 24))/255.0 : 1.0))
        )
    }
    
    static func showMessage(message: String, minimunInterval: NSTimeInterval, messageType: TWMessageBarMessageType){
        hideLoading()
        
        let messageTimeDict: NSMutableDictionary = NSMutableDictionary()
        
        let date: NSDate? = messageTimeDict.objectForKey(message) as? NSDate
        
        if date != nil && NSDate().timeIntervalSinceDate(date!) <= minimunInterval{
            return
        }
        
        TWMessageBarManager.sharedInstance().hideAll()
        messageTimeDict.setObject(NSDate(), forKey: message)
        TWMessageBarManager.sharedInstance().showMessageWithTitle(nil, description: message, type: messageType, duration: kDefaultDuration)
        
    }
    
    static func showSuccessMessage(message: String){
        if !message.isEmpty {
            showMessage(message, minimunInterval: kToastMininumInterval, messageType: TWMessageBarMessageType.Success)
        }
    }
    
    static func showErrorMessage(message: String){
        if !message.isEmpty {
            showMessage(message, minimunInterval: kToastMininumInterval, messageType: TWMessageBarMessageType.Error)
        }
    }
    
    static func showLoadingWithMessage(message: String){
        
        var hub: MBProgressHUD
        if let loading = MBProgressHUD.showHUDAddedTo(appWindow(), animated: true){
            loading.mode = MBProgressHUDMode.Indeterminate
            loading.detailsLabelText = message
            hub = loading
        }else{
            hub = createHUDMessage(message, mode: MBProgressHUDMode.Indeterminate)
        }
        
        hub.alpha = 0
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            hub.alpha = 0.6
        })
    }
    
    static func hideLoading(){
        MBProgressHUD.hideAllHUDsForView(appWindow(), animated: true)
    }
    
    static func createHUDMessage(message: String, mode: MBProgressHUDMode) ->MBProgressHUD{
        let hub = MBProgressHUD(window: appWindow())
        hub.removeFromSuperViewOnHide = true
        hub.mode = mode
        hub.detailsLabelText = message
        hub.detailsLabelFont = UIFont(name: "Avenir-Medium", size: 16)
        appWindow().addSubview(hub)
        hub.show(false)
        
        return hub
    }
    
    static func showImagePickerControllerInViewController(viewController: UIViewController?, addtionalConstruction: ((picker: UIImagePickerController) -> Void), didFinishPickingMedia: (info: NSDictionary) -> Void, didCancel: () -> Void){
        
        guard let _ = viewController else{
            return
        }
        
        let statusBarHidden = UIApplication.sharedApplication().statusBarHidden
        
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        imagePicker.allowsEditing = true
        
        addtionalConstruction(picker: imagePicker)
        
        if !authImagePick(imagePicker, isShowAlert: true) {
            return;
        }
        
        let time: NSTimeInterval = 2.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(time * Double(NSEC_PER_SEC)))
        
        var hideImagePickerController = {
            imagePicker.dismissViewControllerAnimated(true, completion: nil)
            if statusBarHidden {
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
                })
            }
        }
        
        
        
//        imagePickerController.bk_didCancelBlock = ^(UIImagePickerController *picker) {
//            ZPInvokeBlock(hideImagePickerController);
//            ZPInvokeBlock(didCancel);
//        };
//        imagePickerController.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *meta) {
//            ZPInvokeBlock(hideImagePickerController);
//            ZPInvokeBlock(didFinishPickingMedia, meta);
//        };
//        
//        
//        
//        [ZPControl presentViewController:imagePickerController
//            animated:YES
//            modalPresentationStyle:IPAD_REGULAR ? UIModalPresentationCurrentContext : UIModalPresentationFullScreen
//            completion:^{
//            
//            }];
        
        
        
        
    }
    
    static func authImagePick(picker: UIImagePickerController, isShowAlert: Bool) -> Bool {
        var authPass = true
        var message = ""
        
        if picker.sourceType == UIImagePickerControllerSourceType.Camera {
            let authorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)

            if AVAuthorizationStatus.Restricted == authorizationStatus || AVAuthorizationStatus.Denied == authorizationStatus {
                message = NSLocalizedString("str_var_camera_access_denied_alert_message", comment: "str_var_camera_access_denied_alert_message").uppercaseString
                authPass = false
            }
        } else {
            let status = ALAssetsLibrary.authorizationStatus()
            if status == ALAuthorizationStatus.Restricted || status == ALAuthorizationStatus.Denied {
                message = NSLocalizedString("str_var_photolib_access_denied_alert_message", comment: "str_var_photolib_access_denied_alert_message")
                authPass = false
            }
        }
        
        if !authPass && isShowAlert {
            ZPDialogPopoverView.showDialog(NSLocalizedString("str_camera_access_denied_alert_title", comment: "str_camera_access_denied_alert_title"), message: message, customView: nil, actionTitle: NSLocalizedString("str_camera_access_denied_action_title", comment: "str_camera_access_denied_action_title"), actionBlock: {
                    UIGlobal.openSettingsApp()
                
                }, cancelTitle: NSLocalizedString("str_cancel", comment: "str_cancel"), cancelBlock: {}, buttonType: ZPPopoverButtonType.ZPPopoverButtonNegative)
        }
        return authPass
    }
    
    static func openSettingsApp() {
        if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
    }
}
