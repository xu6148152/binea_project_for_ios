//
//  ZPTableViewButtonCell.swift
//  SportDemo
//
//  Created by Binea Xu on 8/30/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ZPTableViewButtonCell: ZPTableBaseCell {

    enum BUTTON_STYLE{
        case BUTTIONSTYLE_NOMAL//灰色
        case BUTTIONSTYLE_ALERT//红色
        case BUTTIONSTYLE_YELLOW//黄色
    }
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if !selected {
            return
        }
        
        // Configure the view for the selected state
    }
    
    func setButtonCellText(title: String){
        label.text = title
    }
    
    func setButtonCellStyle(btnStyle: BUTTON_STYLE){
        switch btnStyle{
        case .BUTTIONSTYLE_NOMAL:
            self.backgroundColor = UIGlobal.UIColorFromARGB(0x33383C)
            self.label.textColor = UIColor.whiteColor()
            
        case .BUTTIONSTYLE_ALERT:
            self.backgroundColor = UIGlobal.UIColorFromARGB(0xD70505)
            self.label.textColor = UIColor.whiteColor()
            
        case .BUTTIONSTYLE_YELLOW:
            self.backgroundColor = UIGlobal.UIColorFromARGB(0xD1EE00)
            self.label.textColor = UIColor.blackColor()
            
        default:
            self.backgroundColor = UIGlobal.UIColorFromARGB(0x33383C);
            self.label.textColor = UIColor.whiteColor();

        }
    }
    
    static func rowHeight() -> CGFloat{
        return 55.0
    }
    
//    func triggerAction(){
//        triggerActionWithObject()
//    }
//    
//    func triggerActionWithObject(){
//        NSObject.cancelPreviousPerformRequestsWithTarget(self.delegate!)
//        
//        let delay = 2.0 * Double(NSEC_PER_SEC)
//        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        dispatch_after(time, dispatch_get_main_queue(), {
//            NSThread.detachNewThreadSelector(Selector("greetings:"), toTarget:self, withObject: "sunshine")
//        })
//    }
//    
//    func greetings(object: AnyObject?) {
//        println("greetings world")
//        println("attached object: \(object)")
//    }
//    
//    func resignFirstRespons(){
//        if let view = self.superview as? UITableView{
//            view.resignFirstResponder()
//        }
//    }
//    
//    func setButtonCellDelegate(delegate: AnyObject){
//        self.delegate = delegate
//    }
}
