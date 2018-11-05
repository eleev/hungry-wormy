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
    
    weak var worm: WormNode?
    private weak var scene: SKScene?
    private var deathHandler: ()->()
    private var fruitGenerator: FruitGenerator?
    
    private var drawContactPoint: (_ point: CGPoint) -> SKShapeNode = {
        let node = SKShapeNode(circleOfRadius: 10)
        node.zPosition = 100
        node.position = $0
        node.fillColor = .black
        node.strokeColor = .white
        
        let waitAction = SKAction.wait(forDuration: 20)
        let removeAction = SKAction.removeFromParent()
        let actionSequence = SKAction.sequence([waitAction, removeAction])
        node.run(actionSequence)
        
        return node
    }
    private var lastContactPoint: CGPoint? = nil
    
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
        
        lastContactPoint = contact.contactPoint
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        resolveWormWallCollision(for: bodyA, and: bodyB)
        resolveWormSelfCollision(for: bodyA, and: bodyB)
        
        let nodeA = bodyA.node
        let nodeB = bodyB.node
        
        resolveWormGrowing(for: nodeA, and: nodeB)
    }
    
    func didEndPhysicsContact(_ contact: SKPhysicsContact) {
        // Has not been implemented
    }
    
    // MARK: - Private methods
    
    private func resolveWormGrowing(for nodeA: SKNode?, and nodeB: SKNode?) {
        func growWorm(using fruit: FoodNode) {
            fruit.remove()
            
            generateFruit()
            worm?.grow()
        }
        
        if let food = nodeA as? FoodNode, nodeB is WormPartNode {
            growWorm(using: food)
        } else if nodeA is WormPartNode, let food = nodeB as? FoodNode {
            growWorm(using: food)
        }
    }
    
    private func resolveWormWallCollision(for bodyA: SKPhysicsBody, and bodyB: SKPhysicsBody) {
        if bodyA.categoryBitMask == PhysicsTypes.wall.rawValue, bodyB.categoryBitMask == PhysicsTypes.worm.rawValue {
//            debugPrint("Part of the Worm that caused the death: ", bodyB.node?.name as Any)
            
//            let node = drawContactPoint(lastContactPoint!)
//            scene?.addChild(node)
            
            deathHandler()
        } else if bodyA.categoryBitMask == PhysicsTypes.worm.rawValue, bodyB.categoryBitMask == PhysicsTypes.wall.rawValue {
            deathHandler()
        }
    }
    
    private func resolveWormSelfCollision(for bodyA: SKPhysicsBody, and bodyB: SKPhysicsBody) {
        if bodyA.categoryBitMask == PhysicsTypes.wormBody.rawValue || bodyA.categoryBitMask == PhysicsTypes.wormTail.rawValue, bodyB.categoryBitMask == PhysicsTypes.worm.rawValue {
            deathHandler()
        } else if bodyB.categoryBitMask == PhysicsTypes.wormBody.rawValue ||  bodyA.categoryBitMask == PhysicsTypes.wormTail.rawValue, bodyA.categoryBitMask == PhysicsTypes.worm.rawValue {
            deathHandler()
        }
    }
}
