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
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 54, height: 54))
        physicsBody?.isDynamic = false
        physicsBody?.isResting = true
        
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animate() {
        let scaleUp = SKAction.scale(to: 1.0, duration: 1.0)
        let scaleDown = SKAction.scale(to: 0.8, duration: 1.0)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        let foreverSequence = SKAction.repeatForever(sequence)
        run(foreverSequence)
    }
    
    func remove() {
        // Animate the removal
        removeAllActions()
        removeFromParent()

    }
}

class FoodNode: SKSpriteNode {
    
    init(position: CGPoint, zPosition: CGFloat, type: FoodType) {
        let textures = type.textures()
        super.init(texture: textures[0], color: .clear, size: CGSize(width: 64, height: 64))
        
        self.position = position
        self.zPosition = zPosition
        
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 54, height: 54))
        physicsBody?.isDynamic = false
        physicsBody?.isResting = true
        
        animate()
        
        let textureAnimation = SKAction.animate(with: textures, timePerFrame: 0.2)
        let foreverAction = SKAction.repeatForever(textureAnimation)
        run(foreverAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animate() {
        let scaleUp = SKAction.scale(to: 1.0, duration: 1.0)
        let scaleDown = SKAction.scale(to: 0.8, duration: 1.0)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        let foreverSequence = SKAction.repeatForever(sequence)
        run(foreverSequence)
    }
    
    func remove() {
        // Animate the removal
        removeAllActions()
        removeFromParent()
        
    }
    
}

enum FoodType {
    case bee
    case ladybug

    enum Fish {
        case green
        case pink
    }
}

extension FoodType {
    func textures() -> [SKTexture] {
        switch self {
        case .bee:
            return [SKTexture(imageNamed: "bee"), SKTexture(imageNamed: "bee_move")]
        case .ladybug:
            return [SKTexture(imageNamed: "ladybug"), SKTexture(imageNamed: "ladybug_move")]
        }
    }
}
