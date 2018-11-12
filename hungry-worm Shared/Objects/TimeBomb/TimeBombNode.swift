//
//  TimeBombNode.swift
//  hungry-worm iOS
//
//  Created by Astemir Eleev on 12/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class TimeBombNode: SKSpriteNode {
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    init(position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: "timebomb"), color: .clear, size: CGSize(width: 54, height: 54))
        
        self.position = position
        commonInit()
        animate()
    }
    
    // MARK: - Methods
    
    func remove() {
        removeAllActions()
        removeFromParent()
    }
    
    func activate(for spinners: [SpinnerNode]) {
        fatalError("Has not been implemented yet")
    }
    
    // MARK: - Common init
    
    private func commonInit() {
        zPosition = 100
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2.0)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsTypes.timeBomb.rawValue
        physicsBody?.contactTestBitMask = PhysicsTypes.worm.rawValue
        physicsBody?.collisionBitMask = 0
    }
    
    // MARK: - Animation
    
    private func animate() {
        let waitAction = SKAction.wait(forDuration: 0.35)
        
        let shrikWidth = SKAction.resize(toWidth: 44, duration: 0.5)
        let stretchWidth = SKAction.resize(toWidth: 54, duration: 0.5)
        let widthResizeSequence = SKAction.sequence([shrikWidth, stretchWidth, waitAction])
        
        let shrikHeight = SKAction.resize(toHeight: 44, duration: 0.5)
        let stretchHeight = SKAction.resize(toHeight: 54, duration: 0.5)
        let heightResizeSequence = SKAction.sequence([waitAction, shrikHeight, stretchHeight])
        
        let commonSequence = SKAction.sequence([widthResizeSequence, heightResizeSequence])
        let foreverSequence = SKAction.repeatForever(commonSequence)
        
        run(foreverSequence)
    }
    
}
