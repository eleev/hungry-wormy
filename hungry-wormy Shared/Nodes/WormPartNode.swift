//
//  WormPartNode.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class WormPartNode: SKSpriteNode {
    // Has no implementation
}

class WormHeadNode: WormPartNode, Updatable {
    
    // MARK: - Properties
    
    var direction: Direction = .up
    
    // MARK: - Methods
    
    func update() {
        zRotation = direction.toRotationDegrees().toRadians
    }
}

class SnakeTailNode: WormPartNode, Updatable {
    
    // MARK: - Properties
    
    var direction: Direction = .up
    
    // MARK: - Methods
    
    func update() {
        zRotation = direction.reversed().toRotationDegrees().toRadians
    }
}


