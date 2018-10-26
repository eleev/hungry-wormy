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
    
    func produce(from part: SnakeParts) -> SnakePartNode {
        let texture = part.getTexture()
        let node = SnakePartNode(texture: texture, size: nodeSize)
        
        let physicsBody = SKPhysicsBody(rectangleOf: nodeSize)
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        
        node.physicsBody = physicsBody
        return node
    }
}
