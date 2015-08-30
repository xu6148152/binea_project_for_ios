//
//  ZPTableViewTextRowCell.swift
//  SportDemo
//
//  Created by Binea Xu on 8/30/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ZPTableViewTextRowCell:  ZPTableBaseCell, UITextFieldDelegate{

    @IBOutlet weak var lable: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func rowHeight() -> CGFloat{
        return 50
    }
    
}
