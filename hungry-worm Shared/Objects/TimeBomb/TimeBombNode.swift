//
//  TimeBombNode.swift
//  hungry-worm iOS
//
//  Created by Astemir Eleev on 12/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class TimeBombNode: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        zPosition = 100
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2.0)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsTypes.timeBomb.rawValue
        physicsBody?.contactTestBitMask = PhysicsTypes.worm.rawValue
    }
}
