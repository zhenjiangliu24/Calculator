//
//  CalculatorCore.swift
//  Calculator
//
//  Created by ZhongZhongzhong on 2016-07-27.
//  Copyright © 2016 ZhongZhongzhong. All rights reserved.
//

import Foundation


class CalculatorCore: CalculatorCoreProtocol {
    private var accumulator = 0.0
    
    //the array to store the program status, with operand and operation name
    private var internalProgram = [AnyObject]()
    
    typealias PropertyList = AnyObject
    
    //a public over rap of the internal program
    var program: PropertyList{
        get{
            return internalProgram
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    }else if let operation = op as? String{
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    //reset the calculator
    private func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    //public
    var result: Double{
        get{
            return accumulator
        }
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    
    func performOperation(operation: String) {
        internalProgram.append(operation)
        if let symbol = operations[operation] {
            switch symbol {
            case .Constant(let constantValue):
                accumulator = constantValue
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                calculatePendingBinaryOperation()
                pending  = pendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                calculatePendingBinaryOperation()
            }
        }
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double, Double)->Double)
        case Equals
    }
    
    private var pending: pendingBinaryOperationInfo?
    
    struct pendingBinaryOperationInfo {
        var binaryFunction: (Double, Double)->Double
        var firstOperand: Double
    }

    
    private func calculatePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
}