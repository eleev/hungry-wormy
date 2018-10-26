//
//  FruitGenerator.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

struct FruitGenerator {
    
    // MARK: - Properties
    
    private var spawnPoints: [CGPoint]
    private let zPosition: CGFloat
    
    // MARK: - Initializers
    
    init(spawnPoints: [CGPoint], zPosition: CGFloat) {
        self.spawnPoints = spawnPoints
        self.zPosition = zPosition
    }
    
    // MARK: - Methods
    
    mutating func generate() -> FruitNode {
        let randomItem = Item.random() ?? Item.red
        let texture = randomItem.get()
        
        let index = Int.random(in: 0..<spawnPoints.count - 1)
        let point = spawnPoints.remove(at: index)
        
        let node = FruitNode(position: point, zPosition: zPosition, texture: texture)
        return node
    }
    
    func isDrained() -> Bool {
        return spawnPoints.isEmpty
    }
}

extension FruitGenerator: Updatable {
    func update() {
        
    }
}

extension FruitGenerator: PhysicsContactDelegate {
    
    func didBeginPhysicsContact(_ contact: SKPhysicsContact, completion:  @escaping (Bool) -> ()) {
        
        func removeAndComplete(_ fruit: FruitNode) {
            fruit.remove()
            completion(true)
        }
        
        // SnakePart + FruitNode intersection
        if contact.bodyA.node is SnakePartNode, let fruit = contact.bodyB.node as? FruitNode  {
            // Remove fruit and grow the snake
            removeAndComplete(fruit)
        } else if contact.bodyB.node is SnakePartNode, let fruit =  contact.bodyA.node as? FruitNode {
            // Remove fruit and grow the snake
            removeAndComplete(fruit)
        } else {
            completion(false)
        }
    }
    
    func didEndPhysicsContact(_ contact: SKPhysicsContact) {
        // Has no implementation
    }
    
}
