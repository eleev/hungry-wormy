//
//  FruitNode.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class FruitNode: SKSpriteNode {
    
    init(position: CGPoint, zPosition: CGFloat, texture: SKTexture) {
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.position = position
        self.zPosition = zPosition
        physicsBody = SKPhysicsBody(rectangleOf: texture.size())
        physicsBody?.isDynamic = false
        physicsBody?.isResting = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func remove() {
        // Animate the removal
        removeAllActions()
        removeFromParent()

    }
}
