//
//  ZPSingleSelectionTableSectionEntity.swift
//  SportDemo
//
//  Created by Binea Xu on 8/23/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation

class ZPSingleSelectionTableSectionEntity{
    
    var sectionBlock: NSNumber
    init(){
        sectionBlock = NSNumber()
    }
    
    static func sectionEntityFromDictionary(dictionary: NSDictionary) -> ZPSingleSelectionTableSectionEntity{
        
        return ZPSingleSelectionTableSectionEntity()
    }
    
    func sectionRow(row: Int){
        
    }
}