//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Binea Xu on 6/6/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    enum Op : Printable{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description:String{
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
        
    }
    
    init(){
        knowsOps["×"] = Op.BinaryOperation("×", *)
        knowsOps["÷"] = Op.BinaryOperation("÷"){$1 / $0}
        knowsOps["−"] = Op.BinaryOperation("−"){$1 - $0}
        knowsOps["+"] = Op.BinaryOperation("+", +)
        knowsOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    private var knowsOps = [String : Op]()
    
    private var opsStack = [Op]()
    
    func evaluate(ops : [Op]) -> (result:Double?,remaining:[Op]){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                    return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operatoinEvalution = evaluate(remainingOps)
                if let operand = operatoinEvalution.result{
                    return (operand, operatoinEvalution.remaining)
                }
            case .BinaryOperation(_, let operation):
                let op1Evalution = evaluate(remainingOps)
                if let operand1 = op1Evalution.result{
                    let op2Evalution = evaluate(op1Evalution.remaining)
                    if let operand2 = op2Evalution.result{
                        return (operation(operand1, operand2), op2Evalution.remaining)
                    }
                }
           
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double?{
        let (result, remaining) = evaluate(opsStack)
        println("\(opsStack) = \(result) with \(remaining) left over")
        return result
    }
    
    
    func pushOperand(operand: Double) -> Double?{
        opsStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knowsOps[symbol]{
            opsStack.append(operation)
        }
        return evaluate()
    }
}