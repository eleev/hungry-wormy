//
//  SnakeNode.swift
//  snake
//
//  Created by Astemir Eleev on 25/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

protocol Updatable {
    func update()
}

class SnakeNode: SKNode {
    
    // MARK: - Properties
    
    private var model: SnakeModel
    
    // MARK: - Initializsers
    
    init(position: CGPoint, worldSize: WorldSize, initial direction: Direction) {
        model = SnakeModel(worldSize: worldSize, initial: direction)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Could not create an instance of SnakeNode class")
    }
    
    // MARK: - Method
}

extension SnakeNode: Updatable {
    
    func update() {
        fatalError("Has not been implemeneted yet")
    }
}
