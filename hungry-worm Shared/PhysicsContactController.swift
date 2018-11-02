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
    
    private var worm: WormNode
    private var deathHandler: ()->()
    private var fruitGenerator: FruitGenerator
    private var scene: SKScene
    
    // MARK: - Initializers
    
    init(worm: WormNode, fruitGenerator: FruitGenerator, scene: SKScene, deathHandler: @escaping ()->()) {
        self.worm = worm
        self.fruitGenerator = fruitGenerator
        self.scene = scene
        self.deathHandler = deathHandler
    }
    
    func generateFruit() {
        fruitGenerator.removeLastFruit()
        let fruitNode = fruitGenerator.generate()
        scene.addChild(fruitNode)
    }
    
    // MARK: - Conformance to PhysocsContactDelegate protocol
    
    func didBeginPhysicsContact(_ contact: SKPhysicsContact, completion: @escaping (Bool) -> ()) {
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if nodeA is FoodNode, nodeB is WormNode || nodeA is WormNode, nodeB is FoodNode{
            generateFruit()
            worm.grow()
        }
        
        #warning("Handle snake death when hitting a wall")
    }
    
    func didEndPhysicsContact(_ contact: SKPhysicsContact) {
        // Has not been implemented
    }

}
