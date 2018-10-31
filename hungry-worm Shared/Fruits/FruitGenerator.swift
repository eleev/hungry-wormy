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
    private var lastFruit: FoodNode?
    
    // MARK: - Initializers
    
    init(spawnPoints: [CGPoint], zPosition: CGFloat) {
        self.spawnPoints = spawnPoints
        self.zPosition = zPosition
    }
    
    // MARK: - Methods
    
    mutating func generate() -> FoodNode {
        let randomFood =  FoodType.allCases.randomElement() ?? FoodType.bee
        
        
        let index = Int.random(in: 0..<spawnPoints.count)
        let point = spawnPoints.remove(at: index)
        
        let node = FoodNode(position: point, zPosition: zPosition, type: randomFood)
        lastFruit = node
        return node
    }
    
    func removeLastFruit() {
        lastFruit?.remove()
    }
    
    func isDrained() -> Bool {
        return spawnPoints.isEmpty
    }
}

extension FruitGenerator: PhysicsContactDelegate {
    
    func didBeginPhysicsContact(_ contact: SKPhysicsContact, completion:  @escaping (Bool) -> ()) {
        
        func removeAndComplete(_ fruit: FoodNode) {
            fruit.remove()
            completion(true)
        }
        
        // WormPart + FruitNode intersection
        if contact.bodyA.node is WormPartNode, let fruit = contact.bodyB.node as? FoodNode  {
            // Remove fruit and grow the worm
            removeAndComplete(fruit)
        } else if contact.bodyB.node is WormPartNode, let fruit =  contact.bodyA.node as? FoodNode {
            // Remove fruit and grow the worm
            removeAndComplete(fruit)
        } else {
            completion(false)
        }
    }
    
    func didEndPhysicsContact(_ contact: SKPhysicsContact) {
        // Has no implementation
    }
    
}
