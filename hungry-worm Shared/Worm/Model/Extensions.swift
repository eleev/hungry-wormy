//
//  Extensions.swift
//  snake
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import CoreGraphics

extension CGSize {
    
    func scale(for amount: CGFloat) -> CGSize {
        return CGSize(width: width / amount, height: height / amount)
    }
}

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

infix operator -%

extension CGPoint {
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + lhs.y)
    }

    static func -%(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: abs(lhs.x - rhs.x), y: abs(lhs.y - rhs.y))
    }
}
