//
//  SpinnerNode.swift
//  hungry-worm
//
//  Created by Astemir Eleev on 04/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class SpinnerNode: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2.2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsTypes.spinner.rawValue
        physicsBody?.contactTestBitMask = PhysicsTypes.worm.rawValue | PhysicsTypes.wormBody.rawValue | PhysicsTypes.wormTail.rawValue
    }
    
}
