//
//  ViewController.swift
//  lsystem
//
//  Created by Oren Leavitt on 7/1/17.
//  Copyright © 2017 Oren Leavitt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var axiomText: UITextField!
    @IBOutlet weak var ruleText: UITextField!
    @IBOutlet weak var angleText: UITextField!
    @IBOutlet weak var recursionText: UITextField!
    @IBOutlet weak var renderView: LSRenderView!
    
    var lsystem = LSystem()
    var lsystemOutput = LSystemOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recursionText.addTarget(self, action: #selector(didBeginEditing(_:)), for: .editingDidBegin)
        
        if let firstVariable = lsystem.variables.first {
            axiomText.text = lsystem.axiom
            ruleText.text = lsystem.productionRules[firstVariable]
            angleText.text = "\(lsystem.angle)"
            recursionText.text = "\(lsystem.defaultRecursionDepth)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Redraw finished output if size or orientation changes
        renderView.drawOutput(output: lsystemOutput)
    }
    
    func didBeginEditing(_ sender: UITextField) {
        sender.selectAll(sender)
    }
    
    @IBAction func onGo(_ sender: Any) {
        
        axiomText.resignFirstResponder()
        ruleText.resignFirstResponder()
        angleText.resignFirstResponder()
        recursionText.resignFirstResponder()
        
        if let axiom = axiomText.text {
            lsystem.axiom = axiom
        }
        
        if let rule = ruleText.text {
            lsystem.productionRules["F"] = rule
        }
 
        if let angleString = angleText.text {
            if let angle = Double(angleString) {
                lsystem.angle = CGFloat(angle)
            }
        }
        
        if let depthText = recursionText.text {
            if let depth = Int(depthText) {
                print("Rendering L-System to depth: \(depth)")
                lsystemOutput = lsystem.render(toDepth: depth)
                renderView.drawOutput(output: lsystemOutput)
            }
        }
    }

}

