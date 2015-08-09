//
//  UIBarButtonItem+ZPImageName.swift
//  SportDemo
//
//  Created by Binea Xu on 8/8/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

class DismissUIBarButtonItem{
    
    var imageName: NSString = ""{
        didSet{
            
        }
        
        willSet{
            
        }
    }

    func setImageName(imageName: NSString){
        self.imageName = imageName
    }
}
