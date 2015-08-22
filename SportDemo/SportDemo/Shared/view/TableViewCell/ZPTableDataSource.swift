//
//  ZPTableDataSource.swift
//  SportDemo
//
//  Created by Binea Xu on 8/22/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation
import UIKit

protocol ZPTableDataSource: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    func initWithTableEntity()
}