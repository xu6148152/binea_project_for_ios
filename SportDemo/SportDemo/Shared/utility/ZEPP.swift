//
//  ZEPP.swift
//  SportDemo
//
//  Created by Binea Xu on 9/27/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import Foundation

class ZEPP {
    
    static let IPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad
    
    static let IPAD_REGULAR = (IPAD && UIGlobal.appWindow().traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular)
    
    
}