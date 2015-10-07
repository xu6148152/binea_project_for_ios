//
//  AccountRegisterProfileViewController.swift
//  SportDemo
//
//  Created by Binea Xu on 8/16/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

class AccountRegisterProfileViewController : BaseTableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "ZPTablePhotoSelectedCell", bundle: nil), forCellReuseIdentifier: "ZPTablePhotoSelectedCell")
        self.tableView.registerNib(UINib(nibName: "ZPTableViewTextRowCell", bundle: nil), forCellReuseIdentifier: "ZPTableViewTextRowCell")
        self.tableView.registerNib(UINib(nibName: "ZPTableViewButtonCell", bundle: nil), forCellReuseIdentifier: "ZPTableViewButtonCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("ZPTablePhotoSelectedCell", forIndexPath: indexPath)
            (cell as! ZPTablePhotoSelectedCell).setCurrentViewController(self)
            return cell
        }else {
            if indexPath.section == 2 && indexPath.row == 3{
                return self.tableView.dequeueReusableCellWithIdentifier("ZPTableViewButtonCell", forIndexPath: indexPath) 
            }
            return self.tableView.dequeueReusableCellWithIdentifier("ZPTableViewTextRowCell", forIndexPath: indexPath) 
        }

    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 2
        }else {
            return 4
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0
        }
        return 45
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return ZPTablePhotoSelectedCell.rowHeight();
        }
        return ZPTableViewTextRowCell.rowHeight()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if section == 1{
            return NSLocalizedString("str_my_account_play_info", comment: "str_my_account_play_info")
        }else if section == 2{
            return NSLocalizedString("str_add_account_sync_account_title", comment: "str_add_account_sync_account_title")

        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    }
    
    
    
    
    
}