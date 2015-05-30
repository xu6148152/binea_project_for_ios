//
//  ViewController.swift
//  helloworld1
//
//  Created by Binea Xu on 15/2/20.
//  Copyright (c) 2015年 Binea Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        println("Hello, world")
//        let implicitFloat:Float = 4
//        println(implicitFloat)
        
//        let label = "The width is"
//        let width = 94
//        let widthLabel = label
//        println(widthLabel)
        let interestingNumbers = [
            "Prime": [2, 3, 5, 7, 11, 13],
            "Fibonacci": [1, 1, 2, 3, 5, 8],
            "Square": [1, 4, 9, 16, 25],
        ]
        var largest = 0
        var largestType:String = ""
        for (kind, numbers) in interestingNumbers {
            for number in numbers {
                if number > largest {
                    largest = number
                    largestType = kind
                }
            }
        }
//        var result = "largestType \(largestType) largest \(largest)"
        println("largestType \(largestType) largest \(largest)")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

