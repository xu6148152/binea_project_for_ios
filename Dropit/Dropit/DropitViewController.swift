//
//  DropitViewController.swift
//  Dropit
//
//  Created by Binea Xu on 6/22/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController {
    
    @IBOutlet weak var gameView: UIView!
    
    var dropsPerRow = 10
    
    var dropSize : CGSize{
        let size = gameView.bounds.width / CGFloat(dropsPerRow)
        
        return CGSize(width: size, height: size)
    }
    
//    override func viewDidLoad() {
//        var value1 : CGFloat = 1
//        var value2 : CGFloat = 2
//        let size = value1 / value2
//        print("\(value1 / value2)")
//    }
    
    
    private extension CGFloat{
        static func ramdom(max: Int) -> CGFloat{
            return CGFloat(arc4random() % UInt32(max))
        }
    }
    
    private extension UIColor{
        class var random: UIColor{
            
        }
    }

}
