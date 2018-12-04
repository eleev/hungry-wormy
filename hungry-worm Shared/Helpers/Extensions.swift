//
//  Extensions.swift
//  snake
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import CoreGraphics
import SpriteKit

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

extension SKScene {
    
    /// A small fix that resolves the default behavior for nodes that were referenced from differnet .sks files. The thing is that they do not launch their animations by default, so this small `hack` fixes this issue.
    ///
    /// The method should be called in `didMove(to view: SKView)`
    func launchReferenceAnimations() {
        isPaused = true
        isPaused = false
    }
}

extension FloatingPoint {
    var toRadians: Self { return self * .pi / 180 }
    var toDegrees: Self { return self * 180 / .pi }
}


func *(lhs: CGSize, value: CGFloat) -> CGSize {
    return CGSize(width: lhs.width * value, height: lhs.height * value)
}
