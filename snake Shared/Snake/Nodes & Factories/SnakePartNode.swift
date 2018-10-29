//
//  SnakePartNode.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class SnakePartNode: SKSpriteNode {
    // Has no implementation
}

class SnakeHeadNode: SnakePartNode, Updatable {
    
    var direction: Direction = .up
    
    func update() {
        zRotation = direction.toRotationDegrees().toRadians
    }
}

class SnakeTailNode: SnakePartNode, Updatable {
    
    var direction: Direction = .up
 
    func update() {
        zRotation = direction.reversed().toRotationDegrees().toRadians
    }
}


extension FloatingPoint {
    var toRadians: Self { return self * .pi / 180 }
    var toDegrees: Self { return self * 180 / .pi }
}
