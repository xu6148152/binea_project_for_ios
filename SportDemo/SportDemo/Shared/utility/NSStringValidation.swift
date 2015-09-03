//
//  NSStringValidation.swift
//  SportDemo
//
//  Created by Binea Xu on 9/3/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
class NSStringValidation{
    
    static func isValidEmail(email: String) -> Bool{
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        let result = NSPredicate(format: "SELF MATCHES%@", argumentArray: [emailRegex])

        return result.evaluateWithObject(email)
    }
}