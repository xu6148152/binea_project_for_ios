//
//  ZPTableSectionEntity.swift
//  SportDemo
//
//  Created by Binea Xu on 8/23/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

class ZPTableSectionEntity{
    
    var row: NSMutableArray?
    
    var headerType: String?
    var headerTitle: String?
    var footerTitle: String?
    
    var rows: NSArray?
    var rowTypes: NSArray?{
        set{
            
        }
        
        get{
            let set = NSMutableSet()
            for row in _rows{
                set.addObject((row as! ZPTableRowEntity).rowType)
            }
            return set.allObjects as NSArray
        }
    }
    
    var _rows: NSMutableArray{
        set{
            
        }
        
        get{
            return self._rows
        }
    }
    
    init(){
       _rows = NSArray().mutableCopy() as! NSMutableArray
    }
    
    static func sectionEntityFromDictionary(dictionary: NSDictionary) -> ZPTableSectionEntity{
        return ZPTableSectionEntity().initWithDictionary(dictionary)
    }
    
    func initWithDictionary(dictionary: NSDictionary) -> ZPTableSectionEntity{
        headerType = dictionary["ZPSectionHeaderType"] as? String
        headerTitle = NSLocalizedString(dictionary["ZPSectionHeaderTitle"] as! String,
            comment: dictionary["ZPSectionHeaderTitle"] as! String)
        footerTitle = NSLocalizedString(dictionary["ZPSectionFooterTitle"] as! String, comment: dictionary["ZPSectionFooterTitle"] as! String)
        _rows = NSArray().mutableCopy() as! NSMutableArray
        
        let array = dictionary["ZPSectionRows"] as! NSArray
        
        for dict in array{
            _rows.addObject(ZPTableRowEntity.rowEntityFromDictionary(dict as! NSDictionary))
        }
        
        return self
    }
    
    func registerNib(tableView: UITableView){
//        for rowtype in self.rowTypes {
//            if rowtype as String{
//                tableView.registerNib(UINib(nibName: rowtype, bundle: nil), forCellReuseIdentifier: rowtype)
//            }
//        }
    }
}