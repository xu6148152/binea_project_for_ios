//
//  ZPTablePhotoSelectedCell.swift
//  SportDemo
//
//  Created by Binea Xu on 8/29/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ZPTablePhotoSelectedCell: ZPTableBaseCell {

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
        
    }
    
    static func rowHeight() -> Float{
        return 110.0
    }
}
