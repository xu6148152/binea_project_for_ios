//
//  ZPRowEntity.swift
//  SportDemo
//
//  Created by Binea Xu on 8/22/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

class ZPTableRowEntity{
    
    init(dictionary: NSDictionary) {
        //todo
        
        rowType = dictionary["ZPRowType"] as! String
        rowImageUrl = dictionary["ZPRowImageUrl"] as! String
        
//        self.rowTitle = ZPLocalizedString(dictionary[@"ZPRowTitle"]?dictionary[@"ZPRowTitle"]:@"");
        
        rowValue = dictionary["ZPRowValue"] as! String
        rowUnit = dictionary["ZPRowUnit"] as! String
        
//        self.rowTitle2 = ZPLocalizedString(dictionary[@"ZPRowTitle2"]?dictionary[@"ZPRowTitle2"]:@"");
        
        rowValue2 = dictionary["ZPRowValue2"] as! String
        rowUnit2 = dictionary["ZPRowUnit2"] as! String
        
        rowChartStyle = dictionary["ZPRowChartStyle"] as! String
        rowChartArray = dictionary["ZPRowChartArray"] as! NSArray
        
        rowIdentifier = dictionary["ZPRowIdentifier"] as! String
//        self.rowDetailTitle = ZPLocalizedString(dictionary[@"ZPRowDetailTitle"]?dictionary[@"ZPRowDetailTitle"]:@"");
        
        let rowAction = NSSelectorFromString(dictionary["ZPRowAction"] as! String);
    }
    
    enum ZPTextRowCellType{
        case ZPTextRowCellTypeNomal
        case ZPTextRowCellTypeEmail
        case ZPTextRowCellTypePassword
        case ZPTextRowCellTypeAge
        case ZPTextRowCellTypeHeight
        case ZPTextRowCellTypeWeight
        case ZPTextRowCellTypeEditEmail
        case ZPTextRowCellTypeEditPassword
    }
    
    
    var rowType: String = ""
    var rowAction: Selector = nil
    var rowImageUrl: String = ""
    
    var rowTitle: String = ""
    var rowValue: String = ""
    var rowUnit: String = ""
    var rowDetailTitle: String = ""
    
    var rowTitle2: String = ""
    var rowValue2: String = ""
    var rowUnit2: String = ""
    
    var rowChartStyle: String = ""
    var rowChartArray: NSArray = []
    
    var rowIdentifier: String = ""
    
    var rowEntityFromDictionary: NSDictionary = [:]
    
    static func rowEntityFromDictionary(directory: NSDictionary) -> ZPTableRowEntity{
        return ZPTableRowEntity(dictionary: directory)
    }
    
    func heightInTableView(tableView: UITableView) -> CGFloat{
        let clazz: AnyClass! = NSClassFromString(rowType as String)
        let cell = clazz as? ZPTableBaseCell
        if cell != nil {

            let height = cell?.rowHeight
            if height >= 0{
                return height!
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(rowType as String)
                //TODO
                return 0
            }
        }
        return 0
    }
    
    func cellInTableView(tableView: UITableView, withDelegate: AnyObject) -> ZPTableBaseCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(rowType) as! ZPTableBaseCell
        cell.delegate = withDelegate
        cell.setCellEntity(self)
        return cell
    }
    
    
}