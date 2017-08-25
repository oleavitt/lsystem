//
//  LSystem.swift
//  lsystem
//
//  Created by Oren Leavitt on 7/1/17.
//  Copyright © 2017 Oren Leavitt. All rights reserved.
//

import Foundation
import CoreGraphics

struct LSystemOutput {
    var points:[CGPoint] = [CGPoint.zero]
    var bounds:CGRect = CGRect.zero
}

/// Each instance represents a set of rules for rendering a particular L-System
class LSystem {
    
    // The components that define the L-System to be rendered
    // Set the default values to generate one segment of a Koch snowflake
    var constants:[String:CGFloat] = ["+":60.0,"-":-60.0]
    // A "no draw" move only rule can be defined as an empty value - e.g. "B" in the Cantor line:
    // axiom = "A"
    // productionRules = ["A":"ABA", "B":"BBB"]
    var productionRules:[String:String] = ["F":"F+F--F+F"]
    var axiom = "F--F--F"
    //var axiom = "F"
    var variables:[String] = ["F"]
    var defaultRecursionDepth = 3
    var lineWidth = 0
    var angle:CGFloat = 60.0 {
        didSet {
            constants["+"] = angle
            constants["-"] = -angle
        }
    }
    
    // Special point to indicate end of current path and that next point is move to start of a new path.
    static let gigantic:CGFloat = 1000000000.0
    static let endPoint = CGPoint(x: gigantic, y: gigantic)
    
    /// Render the L-System based on components above
    ///
    /// - Parameter toDepth: Recursion depth
    /// - Returns: An array of CGPoints
    func render(toDepth:Int) -> LSystemOutput {
        
        // Start new output struct
        var output = LSystemOutput()
        
        recurseProductionRule(axiom, depth: toDepth, direction: 0.0, output: &output)
        
        var minX:CGFloat = LSystem.gigantic
        var maxX:CGFloat = -LSystem.gigantic
        var minY:CGFloat = LSystem.gigantic
        var maxY:CGFloat = -LSystem.gigantic
        for p in output.points.filter({ (pt) in return !pt.isEndPoint } ) {
            if p.x < minX { minX = p.x }
            if p.x > maxX { maxX = p.x }
            if p.y < minY { minY = p.y }
            if p.y > maxY { maxY = p.y }
        }
        if fabs(maxX - minX) < 0.1 {
            maxX = maxX + 0.05
            minX = minX - 0.05
        }
        if fabs(maxY - minY) < 0.1 {
            maxY = maxY + 0.05
            minY = minY - 0.05
        }
        output.bounds = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        
        return output
    }
    
    // Internal state variables while rendering
 
    private func recurseProductionRule(_ rule:String, depth:Int, direction:CGFloat, output:inout LSystemOutput) {
        
        // Otherwise, step through current production rule, apply constants, and recursively step into each variable
        var newDirection = direction
        var lastPoint = output.points.last ?? CGPoint.zero
        var beginDraw = false
        var doDraw = true
        
        for c in rule.characters {
            switch c {
            case "+":
                newDirection = newDirection + angle
                
            case "-":
                newDirection = newDirection - angle
                
            default:
                // If depth is zero, emit a point to the point list
                if depth < 1 {
                    if beginDraw {
                        output.points.append(LSystem.endPoint)
                        output.points.append(lastPoint)
                        beginDraw = false
                        doDraw = true
                    }
                    let directionRad = newDirection * CGFloat(Double.pi / 180.0)
                    let dx = cos(directionRad)
                    let dy = sin(directionRad)
                    lastPoint.x += dx
                    lastPoint.y += dy
                    if doDraw {
                        output.points.append(lastPoint)
                    }
                } else if let subRule = productionRules[String(c)] {
                    // c is a variable - pick out it's rule and recurse into it.
                    recurseProductionRule(subRule, depth: depth - 1, direction: newDirection, output: &output)
                }
                
            }
        }
    }
}
