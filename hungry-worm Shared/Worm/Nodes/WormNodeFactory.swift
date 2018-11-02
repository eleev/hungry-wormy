//
//  WormNodeFactory.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

struct WormNodeFactory {
    
    // MARK: - Properties
    
    var nodeSize: CGSize
    var physicsBodySize: CGSize
    var zPosition: CGFloat
    
    // MARK: - Initializers
    
    init(nodeSize: Int, zPosition: CGFloat) {
        self.nodeSize = CGSize(width: nodeSize, height: nodeSize)
        self.zPosition = zPosition
        
        physicsBodySize = self.nodeSize.scale(for: 1.1)
    }
    
    // MARK: - Methods
    
    func produceHead() -> WormHeadNode {
        let headClosedTexture = SKTexture(imageNamed: "head-closed")
        let node = WormHeadNode(texture: headClosedTexture, size: nodeSize)
        
        let animation = SKAction.animate(with: [headClosedTexture, SKTexture(imageNamed: "head-open")], timePerFrame: 0.25)
        let foreverAnimation = SKAction.repeatForever(animation)
        node.run(foreverAnimation)
        
        node.physicsBody = producePhysicsBody()
        return node
    }
    
    func produceBody() -> WormPartNode {
        let headClosedTexture = SKTexture(imageNamed: "body")
        let node = WormPartNode(texture: headClosedTexture, size: nodeSize)
        node.physicsBody = producePhysicsBody()
        return node
    }
    
    func produceTail() -> SnakeTailNode {
        let headClosedTexture = SKTexture(imageNamed: "tail")
        let node = SnakeTailNode(texture: headClosedTexture, size: nodeSize)
        node.zRotation = CGFloat(180.0).toRadians
        node.physicsBody = producePhysicsBody()
        return node
    }
    
    // MARK: - Private methods
    
    private func producePhysicsBody() -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: physicsBodySize)
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.contactTestBitMask = PhysicsTypes.snake.rawValue | PhysicsTypes.wall.rawValue | PhysicsTypes.fruit.rawValue
        physicsBody.categoryBitMask = PhysicsTypes.snake.rawValue
        physicsBody.collisionBitMask = 0
        
        return physicsBody
    }
    
}

enum PhysicsTypes: UInt32 {
    case snake = 1
    case wall = 2
    case fruit = 4
}
