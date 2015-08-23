//
//  ZPTableEntity.swift
//  SportDemo
//
//  Created by Binea Xu on 8/22/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation

class ZPTableEntity {
    var sections: NSMutableArray = []
    
    init(){
        sections = NSArray().mutableCopy() as! NSMutableArray
    }
    
    static func tableEntityFromPlist(pListFile: String) -> ZPTableEntity{
        var dictory: NSDictionary?
        var array: NSArray?
        if let path = NSBundle.mainBundle().pathForResource(pListFile, ofType: "plist"){
            let array = NSMutableArray(contentsOfFile: path)
//            dictory = NSDictionary(contentsOfFile: path)
            
        }
        
        let entity = ZPTableEntity()
        if array != nil{
            entity.initWithArray(array!)
        }
        
        return entity
        
    }
    
    func initWithArray(array: NSArray){
        for dict in array{
            if let di = dict as? NSDictionary{
                if di["ZPSectionType"] as! String == "ZPSingleSelectionTableSectionEntity"{
                    sections.addObject(di)
                }
            }
            
        }
    }
}
