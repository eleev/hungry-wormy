//
//  StarNode.swift
//  hungry-worm
//
//  Created by Astemir Eleev on 13/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class StarNode: SKSpriteNode {
    
    func animate() {
        let goldColor = SKColor(red: 1.0/255, green: 1.0/212, blue: 1.0/121, alpha: 1.0)

        let colorize = SKAction.colorize(with: goldColor, colorBlendFactor: 1.0, duration: 1.5)
        
        let width = size.width
        let tenthWidth = (size.width / 10)
        
        let scaleWideUp = SKAction.resize(toWidth: width + tenthWidth, duration: 0.75)
        let scaleWidthDown = SKAction.resize(toWidth: width, duration: 0.75)
        
        let scaleSequence = SKAction.sequence([scaleWideUp, scaleWidthDown])
        let animationGroup = SKAction.group([scaleSequence, colorize])
        
        run(animationGroup)
    }
    
}
