//
//  CalculatorCoreProtocol.swift
//  Calculator
//
//  Created by ZhongZhongzhong on 2016-07-27.
//  Copyright © 2016 ZhongZhongzhong. All rights reserved.
//

import Foundation

protocol CalculatorCoreProtocol {
    var result: Double{get}
    func setOperand(operand: Double)
    func performOperation(operation: String)
}
