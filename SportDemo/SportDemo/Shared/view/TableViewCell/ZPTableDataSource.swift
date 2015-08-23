//
//  ZPTableDataSource.swift
//  SportDemo
//
//  Created by Binea Xu on 8/22/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

class ZPTableDataSource: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    var mEntity: ZPTableEntity
    
    func initWithTableEntity(){
        
    }
    
    func initTableView(){
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 
    }
    
}