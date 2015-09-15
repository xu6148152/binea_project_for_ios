//
//  LeftViewController.swift
//  SlidingMenuLikeQQ
//
//  Created by Binea Xu on 9/14/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var settingTableView: UITableView!
    
    
    @IBOutlet weak var heightLayoutConstraintOfSettingTableView: NSLayoutConstraint!
    
    let titlesDictionary = ["开通会员", "QQ钱包", "网上营业厅", "个性装扮", "我的收藏", "我的相册", "我的文件"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView()
        
        heightLayoutConstraintOfSettingTableView.constant = Common.screenHeight < 500 ? Common.screenHeight * (568 - 221) / 568 : 347
        
        self.view.frame = CGRectMake(0, 0, 320*0.78, Common.screenHeight)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("leftViewCell", forIndexPath: indexPath)
//        cell.backgroundColor = UIColor.clearColor()
//        cell.textLabel!.text = titlesDictionary[indexPath.row]
        
        return UITableViewCell()
        
    }
    
    

    
}
