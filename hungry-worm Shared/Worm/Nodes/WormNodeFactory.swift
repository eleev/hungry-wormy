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
        node.name = "Worm Head"
        
        let animation = SKAction.animate(with: [headClosedTexture, SKTexture(imageNamed: "head-open")], timePerFrame: 0.25)
        let foreverAnimation = SKAction.repeatForever(animation)
        node.run(foreverAnimation)
        
        let physicsBody = SKPhysicsBody(rectangleOf: physicsBodySize)
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = PhysicsTypes.worm.rawValue
        physicsBody.contactTestBitMask = PhysicsTypes.wormBody.rawValue | PhysicsTypes.wormTail.rawValue | PhysicsTypes.wall.rawValue | PhysicsTypes.fruit.rawValue
        physicsBody.collisionBitMask = 0
        physicsBody.usesPreciseCollisionDetection = true
        
        node.physicsBody = physicsBody
        
        return node
    }
    
    func produceBody() -> WormPartNode {
        let headClosedTexture = SKTexture(imageNamed: "body")
        let node = WormPartNode(texture: headClosedTexture, size: nodeSize)
        node.name = "Worm Body"
        
        let physicsBody = SKPhysicsBody(rectangleOf: physicsBodySize)
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = PhysicsTypes.wormBody.rawValue
        physicsBody.contactTestBitMask = PhysicsTypes.worm.rawValue | PhysicsTypes.wall.rawValue | PhysicsTypes.fruit.rawValue
        physicsBody.collisionBitMask = 0
        physicsBody.usesPreciseCollisionDetection = true
        node.physicsBody = physicsBody
        
        return node
    }
    
    func produceTail() -> SnakeTailNode {
        let headClosedTexture = SKTexture(imageNamed: "tail")
        let node = SnakeTailNode(texture: headClosedTexture, size: nodeSize)
        node.name = "Worm Tail"
        node.zRotation = CGFloat(180.0).toRadians
        
        let physicsBody = SKPhysicsBody(rectangleOf: physicsBodySize)
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = PhysicsTypes.wormTail.rawValue
        physicsBody.contactTestBitMask = PhysicsTypes.worm.rawValue | PhysicsTypes.wall.rawValue | PhysicsTypes.fruit.rawValue
        physicsBody.collisionBitMask = 0
        physicsBody.usesPreciseCollisionDetection = true
        node.physicsBody = physicsBody
        
        return node
    }
}
