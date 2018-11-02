//
//  PhysicsContactController.swift
//  hungry-worm
//
//  Created by Astemir Eleev on 02/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class PhysicsContactController: PhysicsContactDelegate {
    
    // MARK: - Properties
    
    private weak var worm: WormNode?
    private weak var scene: SKScene?
    private var deathHandler: ()->()
    private var fruitGenerator: FruitGenerator?
    
    // MARK: - Initializers
    
    init(worm: WormNode, fruitGenerator: FruitGenerator, scene: SKScene, deathHandler: @escaping ()->()) {
        self.worm = worm
        self.fruitGenerator = fruitGenerator
        self.scene = scene
        self.deathHandler = deathHandler
    }
    
    func generateFruit() {
        fruitGenerator?.removeLastFruit()
        let fruitNode = fruitGenerator?.generate()
        scene?.addChild(fruitNode!)
    }
    
    // MARK: - Conformance to PhysocsContactDelegate protocol
    
    func didBeginPhysicsContact(_ contact: SKPhysicsContact, completion: @escaping (Bool) -> () = { _ in }) {
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        let nodeA = bodyA.node
        let nodeB = bodyB.node
        
        resolveWormGrowing(for: nodeA, and: nodeB)
        resolveWormWallCollision(for: bodyA, and: bodyB)
    }
    
    func didEndPhysicsContact(_ contact: SKPhysicsContact) {
        // Has not been implemented
    }

    
    // MARK: - Private methods
    
    private func resolveWormGrowing(for nodeA: SKNode?, and nodeB: SKNode?) {
        func growWorm() {
            generateFruit()
            worm?.grow()
        }
        
        if nodeA is FoodNode, nodeB is WormPartNode {
            growWorm()
        } else if nodeA is WormPartNode, nodeB is FoodNode {
            growWorm()
        }
    }
    
    private func resolveWormWallCollision(for bodyA: SKPhysicsBody, and bodyB: SKPhysicsBody) {
        if bodyA.categoryBitMask == PhysicsTypes.wall.rawValue, bodyB.categoryBitMask == PhysicsTypes.snake.rawValue {
            deathHandler()
        } else if bodyA.categoryBitMask == PhysicsTypes.snake.rawValue, bodyB.categoryBitMask == PhysicsTypes.wall.rawValue {
            deathHandler()
        }
    }
}
