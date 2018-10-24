//
//  CellMovement.swift
//  snake
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import CoreGraphics

struct CellMovement: MovementProtocol {
    
    var direction: Direction
    
    init(startingDirection: Direction) {
        direction = startingDirection
    }
    
    func move(point: CGPoint, withRespectTo worldSize: WorldSize) -> CGPoint {
        var x = point.x
        var y = point.y
        let newWorldSize = (worldSize - 1).toCGFloat
        
        switch direction {
        case .left:
            x -= 1
            if x < 0 { x = newWorldSize }
        case .up:
            y -= 1
            if y < 0 { y = newWorldSize }
        case .right:
            x += 1
            if x > worldSize.toCGFloat { x = 0 }
        case .down:
            y += 1
            if y > worldSize.toCGFloat { y = 0 }
        }
        return CGPoint(x: x, y: y)
    }
}
