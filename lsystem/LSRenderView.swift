//
//  LSRenderView.swift
//  lsystem
//
//  Created by Oren Leavitt on 7/1/17.
//  Copyright © 2017 Oren Leavitt. All rights reserved.
//

import UIKit

class LSRenderView: UIView {

    var lineColor: UIColor = UIColor.black
    
    var points:[CGPoint] = []
    
    func drawOutput(output: LSystemOutput) {
        
        // Get the rect of the view and fit/center the array of points in it

        points = []
        let inset:CGFloat = 10.0
        let viewRect = bounds.insetBy(dx: inset, dy: inset)

        var scale = CGSize(width: 1.0, height: 1.0)
        var offset = CGPoint.zero
        
        if viewRect.width < viewRect.height {
            // Scale by width and center verticaly
            let s = viewRect.width / output.bounds.width
            scale = CGSize(width: s, height: s)
            offset = CGPoint(x: inset, y: (viewRect.height - output.bounds.height * s) / 2 + inset)
        } else {
            // Scale by height and center horizontally
            let s = viewRect.height / output.bounds.height
            scale = CGSize(width: s, height: s)
            offset = CGPoint(x: (viewRect.width - output.bounds.width * s) / 2 + inset, y: inset)
        }
        
        if output.bounds.minX < 0.0 {
            offset.x -= output.bounds.minX * scale.width
        }
        if output.bounds.maxY > 0.0 {
            offset.y += output.bounds.maxY * scale.height
        }
        
        // Scale and translate L-System points to fit in view
        points = output.points.map({ (pt) in
            if pt.isEndPoint {
                return pt
            }
            return CGPoint(x: pt.x * scale.width + offset.x,
                           y: offset.y - pt.y * scale.height)
        })
        
        // Draw it on the next refresh
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {

        let lineWidth: CGFloat = 2.0
        
        let path = UIBezierPath()
        
        path.lineWidth = lineWidth

        var isFirst = true
        for p in points {
            
            if p.isEndPoint {
                isFirst = true
            } else if isFirst {
                path.move(to: p)
                isFirst = false
            } else {
                path.addLine(to: p)
            }
        }
        
        //set the stroke color
        lineColor.setStroke()
        
        //draw the stroke
        path.stroke()
        
    }
}
