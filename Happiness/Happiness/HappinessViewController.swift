//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Binea Xu on 6/7/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            faceView.dataSource = self
        }
    }
    
    var smileness:Double = 0{//0 very sad 100 estatic
        didSet{
            smileness = max(min(smileness, 100), 0)
            faceView.setNeedsDisplay()
        }
    }

    func faceViewForDataSource(sender:FaceView) ->Double?{
        return (smileness - 50) / 50
    }
}
