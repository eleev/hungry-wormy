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
    private var completionHandler: ()->()
    private var fruitGenerator: FruitGenerator?
    private var timeBombGenerator: TimeBombGenerator?
    
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
    
    init(worm: WormNode,
         fruitGenerator: FruitGenerator,
         timeBombGenerator: TimeBombGenerator,
         scene: SKScene,
         deathHandler: @escaping ()->(),
         completionHandler: @escaping ()->()) {
        self.worm = worm
        self.fruitGenerator = fruitGenerator
        self.timeBombGenerator = timeBombGenerator
        self.scene = scene
        self.deathHandler = deathHandler
        self.completionHandler = completionHandler
    }
    
    func generateFruit() {
        fruitGenerator?.removeLastFruit()
        guard let fruitNode = fruitGenerator?.generate() else {
            // All the fruits have been eaten, the main and the only condition for completion has been fulfilled
            completionHandler()
            return
        }
        scene?.addChild(fruitNode)
    }
    
    func generateTimeBomb() {
        timeBombGenerator?.removeLast()
        
        if let bombNode = timeBombGenerator?.generate() {
            let waitDuration = TimeInterval((3...15).randomElement() ?? 3)
            
            let wait = SKAction.wait(forDuration: waitDuration)
            let spawnBombNode = SKAction.run { [weak self] in
                bombNode.alpha = 0.0
                self?.scene?.addChild(bombNode)
                bombNode.run(SKAction.fadeAlpha(to: 1.0, duration: 1.5))
            }
            let sequence = SKAction.sequence([wait, spawnBombNode])
            scene?.run(sequence)
        }
    }
    
    // MARK: - Conformance to PhysocsContactDelegate protocol
    
    func didBeginPhysicsContact(_ contact: SKPhysicsContact, completion: @escaping (Bool) -> () = { _ in }) {
        
        lastContactPoint = contact.contactPoint
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        resolveWormWallCollision(               for: bodyA, and: bodyB  )
        resolveWormSelfCollision(               for: bodyA, and: bodyB  )
        resolveWormSpinnerCollision(            for: bodyA, and: bodyB  )
        resolveWormSpinnerHeadTailCollision(    for: bodyA, and: bodyB  )
        
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
    
    private func resolveWormSpinnerCollision(for bodyA: SKPhysicsBody, and bodyB: SKPhysicsBody) {
        
        func splitIfPossible(for bodyPart: SKNode?) {
            if let contactNode = bodyPart as? WormPartNode {
                worm?.split(at: contactNode)
            }
        }
        
        if bodyA.categoryBitMask == PhysicsTypes.spinner.rawValue, bodyB.categoryBitMask == PhysicsTypes.wormBody.rawValue {
            splitIfPossible(for: bodyB.node)
        } else if bodyB.categoryBitMask == PhysicsTypes.spinner.rawValue, bodyA.categoryBitMask == PhysicsTypes.wormBody.rawValue {
            splitIfPossible(for: bodyA.node)
        }
    }
    
    private func resolveWormSpinnerHeadTailCollision(for bodyA: SKPhysicsBody, and bodyB: SKPhysicsBody) {
        
        if bodyA.categoryBitMask == PhysicsTypes.spinner.rawValue, bodyB.categoryBitMask == PhysicsTypes.worm.rawValue {
            deathHandler()
        } else if bodyB.categoryBitMask == PhysicsTypes.spinner.rawValue, bodyA.categoryBitMask == PhysicsTypes.worm.rawValue {
            deathHandler()
        }
    }
    
    private func resolveTimeBombCollision(for bodyA: SKPhysicsBody, and bodyB: SKPhysicsBody) {
        fatalError("The method has not been implemented yet")
//        if bodyA.categoryBitMask == PhysicsTypes.timeBomb.rawValue, bodyB.categoryBitMask == PhysicsTypes.worm.rawValue {
//
//        } else if bodyB.categoryBitMask == PhysicsTypes.timeBomb.rawValue, bodyA.categoryBitMask == PhysicsTypes.worm.rawValue {
//
//        }
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
    
    private func resolveWormTimeBombCollision(for bodyA: SKPhysicsBody, and bodyB: SKPhysicsBody) {
        
        if bodyA.categoryBitMask == PhysicsTypes.worm.rawValue, bodyB.categoryBitMask == PhysicsTypes.timeBomb.rawValue {
            generateTimeBomb()
        } else if bodyB.categoryBitMask == PhysicsTypes.worm.rawValue, bodyA.categoryBitMask == PhysicsTypes.timeBomb.rawValue {
            generateTimeBomb()
        }
    }
    
}
