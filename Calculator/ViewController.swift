//
//  ViewController.swift
//  Calculator
//
//  Created by ZhongZhongzhong on 2016-07-27.
//  Copyright © 2016 ZhongZhongzhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet private weak var displayLabel: UILabel!
    
    private var userIsInput = false
    
    private var displayValue: Double {
        get{
            return Double(displayLabel.text!)!
        }
        set{
            displayLabel.text = String(newValue)
        }
    }
    
    var savedProgram: CalculatorCore.PropertyList?
    
    
    @IBAction func save() {
        savedProgram = Calculator.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            Calculator.program = savedProgram!
            displayValue = Calculator.result
        }
    }

    @IBAction private func digitsTouched(sender: UIButton) {
        let digitsCurrentDisplay = displayLabel.text!
        if userIsInput {
            if let digit = sender.currentTitle{
                displayLabel.text = digitsCurrentDisplay + digit
            }
        }else{
            if let digit = sender.currentTitle {
                displayLabel.text = digit
            }
        }
        userIsInput = true
    }
    
    var Calculator = CalculatorCore()
    @IBAction private func operationTouched(sender: UIButton) {
        if userIsInput {
            Calculator.setOperand(displayValue)
            userIsInput = false
        }
        if let operation = sender.currentTitle {
            Calculator.performOperation(operation)
        }
        displayValue = Calculator.result
    }
    

}

