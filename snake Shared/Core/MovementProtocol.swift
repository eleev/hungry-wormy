//
//  MovementProtocol.swift
//  snake
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import CoreGraphics

protocol MovementProtocol {
    
    var direction: Direction { get }
    
    init(startingDirection: Direction)
    
    func move(point: CGPoint, withRespectTo worldSize: WorldSize) -> CGPoint
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
