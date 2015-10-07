//
//  ZPTableHeaderView.swift
//  SportDemo
//
//  Created by Binea Xu on 10/7/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import Foundation


class ZPTableHeaderView: UITableViewHeaderFooterView {
    
    var title: UILabel
    
    func headerViewForTableView(tableView: UITableView, identifier: String, title: String){
        initWithNothing()
    }
    
    func initWithNothing(){
        self.contentView.backgroundColor = UIGlobal.backgroundColor()
    }
    
    init(identifier: String){
        title = UILabel()
        super.init(reuseIdentifier: identifier)
        contentView.backgroundColor = UIGlobal.backgroundColor()
        title.backgroundColor = UIColor.clearColor()
        title.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
        title.minimumScaleFactor=0.1
        title.adjustsFontSizeToFitWidth = true
        title.accessibilityLabel = "section header"
        contentView.addSubview(title)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class ZPTablePlainHeaderView: ZPTableHeaderView{
    override func headerViewForTableView(tableView: UITableView, identifier: String, title: String) {
        var headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(identifier) as? ZPTableHeaderView
        if headerView == nil {
            headerView = ZPTablePlainHeaderView(identifier: identifier)
        }
        headerView?.title.text = title
    }
}

class ZPTableGroupHeaderView: ZPTableHeaderView{
    override func headerViewForTableView(tableView: UITableView, identifier: String, title: String) {
        
    }
}