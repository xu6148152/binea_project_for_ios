//
//  ZPAccountProfileDataSource.swift
//  SportDemo
//
//  Created by Binea Xu on 8/22/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

class ZPAccountProfileDataSource{
    
    var mIsSocial: Bool = false
    
    func initWithTableView(tableView: UITableView, isSocial: Bool, userId: NSNumber){
        mIsSocial = isSocial
        
        if(mIsSocial){
            
        }else{
            
        }
    }
    
    func initWithTableEntity(){
        
    }
}