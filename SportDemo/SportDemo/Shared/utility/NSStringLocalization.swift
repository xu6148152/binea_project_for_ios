//
//  NSStringLocalization.swift
//  SportDemo
//
//  Created by Binea Xu on 9/12/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation

class NSStringLocalization{
    
    static func StringLocalization(str: String) -> String{
        return NSLocalizedString(str, comment: str)
    }
}