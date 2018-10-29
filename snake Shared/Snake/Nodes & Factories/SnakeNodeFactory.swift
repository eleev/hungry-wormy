//
//  SnakeNodeFactory.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

struct SnakeNodeFactory {
    
    // MARK: - Properties
    
    var nodeSize: CGSize
    var zPosition: CGFloat
    
    // MARK: - Initializers
    
    init(nodeSize: Int, zPosition: CGFloat) {
        self.nodeSize = CGSize(width: nodeSize, height: nodeSize)
        self.zPosition = zPosition
    }
    
    // MARK: - Methods
    
    func produceRandom() -> SnakePartNode? {
        guard let randomSnakePart = SnakeParts.random() else {
            return nil
        }
        return produce(from: randomSnakePart)
    }
    
    func produceHead() -> SnakeHeadNode {
        let headClosedTexture = SKTexture(imageNamed: "head-closed")
        let node = SnakeHeadNode(texture: headClosedTexture, size: nodeSize)
        
        let animation = SKAction.animate(with: [headClosedTexture, SKTexture(imageNamed: "head-open")], timePerFrame: 0.25)
        let foreverAnimation = SKAction.repeatForever(animation)
        node.run(foreverAnimation)
        
        let physicsBody = SKPhysicsBody(rectangleOf: nodeSize)
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.contactTestBitMask = PhysicsTypes.snake.rawValue | PhysicsTypes.wall.rawValue | PhysicsTypes.fruit.rawValue
        physicsBody.categoryBitMask = PhysicsTypes.snake.rawValue
        physicsBody.collisionBitMask = 0
        
        node.physicsBody = physicsBody
        return node
    }
    
    func produceBody() -> SnakePartNode {
        let headClosedTexture = SKTexture(imageNamed: "body")
        let node = SnakePartNode(texture: headClosedTexture, size: nodeSize)
        
        let physicsBody = SKPhysicsBody(rectangleOf: nodeSize)
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.contactTestBitMask = PhysicsTypes.snake.rawValue | PhysicsTypes.wall.rawValue | PhysicsTypes.fruit.rawValue
        physicsBody.categoryBitMask = PhysicsTypes.snake.rawValue
        physicsBody.collisionBitMask = 0
        
        node.physicsBody = physicsBody
        return node
    }
    
    
    func produce(from part: SnakeParts) -> SnakePartNode {
        let texture = part.getTexture()
        let node = SnakePartNode(texture: texture, size: nodeSize)
        
        let physicsBody = SKPhysicsBody(rectangleOf: nodeSize)
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.contactTestBitMask = PhysicsTypes.snake.rawValue | PhysicsTypes.wall.rawValue | PhysicsTypes.fruit.rawValue
        physicsBody.categoryBitMask = PhysicsTypes.snake.rawValue
        physicsBody.collisionBitMask = 0
        
        node.physicsBody = physicsBody
        return node
    }
}

enum PhysicsTypes: UInt32 {
    case snake = 1
    case wall = 2
    case fruit = 4
}
