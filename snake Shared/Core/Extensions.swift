//
//  Extensions.swift
//  snake
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import CoreGraphics

extension Int {
    
    var toCGFloat: CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat {
    
    var toInt: Int {
        return Int(self)
    }
}
