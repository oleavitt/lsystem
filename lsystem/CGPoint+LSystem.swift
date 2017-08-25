//
//  CGPoint+LSystem.swift
//  lsystem
//
//  Created by Oren Leavitt on 7/2/17.
//  Copyright © 2017 Oren Leavitt. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
    
    var isEndPoint: Bool {
        get {
            return x == LSystem.gigantic || y == LSystem.gigantic
        }
    }
}
