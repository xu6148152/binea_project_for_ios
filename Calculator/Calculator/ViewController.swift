//
//  ViewController.swift
//  Calculator
//
//  Created by Binea Xu on 5/30/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var mDisplay: UILabel!

    var useIsInMiddleOfTypingANumber = false
    
    @IBAction func displayDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("digit = \(digit)")
        if(useIsInMiddleOfTypingANumber){
            mDisplay.text = mDisplay.text! + digit
        }else{
            mDisplay.text = digit
            useIsInMiddleOfTypingANumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        if useIsInMiddleOfTypingANumber{
            enter()
        }
        
        let operation = sender.currentTitle!
        switch operation{
            case "C":
                numberStack.removeAll(keepCapacity: false)
                displayValue = 0
                break
//            case "±":
//
//            case "%":
//                println("\(displayValue/100)")
//                mDisplay.text! = NSNumberFormatter().stringFromNumber(displayValue / 100)!

            
        
            case "×":
                performOperation{$0 * $1}
            case "÷":
                performOperation{$1 / $0}
            case "−":
                performOperation{$1 - $0}
            case "+":
                performOperation{$0 + $1}
            case "√":
                performOperation{sqrt($0)}
            default:
                break
        }
    }
    
    func performOperation(operation: (Double, Double) ->Double){
        if numberStack.count >= 2{
            
            displayValue = operation(numberStack.removeLast(), numberStack.removeLast())
            println("\(displayValue)")
            enter()
        }
    }
    
    private func performOperation(operation: (Double) ->Double){
        if numberStack.count >= 1{
            displayValue = operation(numberStack.removeLast())
            enter()
        }
    }
    
    
    var numberStack = Array<Double>()
    

    @IBAction func enter() {
        useIsInMiddleOfTypingANumber = false
        numberStack.append(displayValue)
        println("\(numberStack)")
    }
    
    var displayValue:Double{
        get{
            return NSNumberFormatter().numberFromString(mDisplay.text!)!.doubleValue
        }
        set{
            mDisplay.text = "\(newValue)"
            useIsInMiddleOfTypingANumber = false
        }
    }
}

