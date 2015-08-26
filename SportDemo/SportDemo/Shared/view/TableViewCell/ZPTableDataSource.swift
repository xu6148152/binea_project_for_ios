//
//  ZPTableDataSource.swift
//  SportDemo
//
//  Created by Binea Xu on 8/22/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

class ZPTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    var mEntity: ZPTableEntity?
    var _delegate: AnyObject?
    
    
    
    func initWithTableEntity(){
        
    }
    
    func initTableView(){
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        return mEntity!.cellAtIndexPath(indexPath, tableView: tableView, widthDelegate: _delegate!)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
}