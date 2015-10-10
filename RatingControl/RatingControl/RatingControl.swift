//
//  RatingControl.swift
//  RatingControl
//
//  Created by Binea Xu on 10/10/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit

class RatingControl: UIView{
    // MARK: Properties
    
    var rating = 0
    var ratingButtons = [UIButton]()
    
    
    //MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initButtons()
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 240, height: 44)
    }
    
    func initButtons() {
        
        
        for _ in 0..<5 {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            button.backgroundColor = UIColor.redColor()
            button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
            ratingButtons += [button]
            addSubview(button)
        }
    }
    
    // MARK: layout
    override func layoutSubviews() {
        
        //set the button's width and height to a square the size of the frame's height
        let buttonSize = Int(frame.size.height)
        
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus spacing
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (44 + 5))
            button.frame = buttonFrame
        }
    }
    
    //MARK: Button Action
    
    func ratingButtonTapped(button: UIButton) {
        print("Button pressed")
    }
    
    
    
    
    
}