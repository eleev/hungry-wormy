//
//  SnakeNode.swift
//  snake
//
//  Created by Astemir Eleev on 25/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class SnakeNode: SKNode {
    
    // MARK: - Properties
    
    private let factory: SnakeNodeFactory
    private let model: SnakeModel
    private var nodes: [SnakePartNode] = []
    
    let SIZE = 64
    
    // MARK: - Initializsers
    
    init(position: CGPoint, worldSize: WorldSize, initial direction: Direction) {
        model = SnakeModel(worldSize: worldSize, initial: direction)
        factory = SnakeNodeFactory(nodeSize: SIZE, zPosition: 50)
        
        super.init()
        
        let node = factory.produceRandom() ?? factory.produce(from: .chicken)
        node.position = position
        addChild(node)
        nodes += [node]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Could not create an instance of SnakeNode class")
    }
    
    // MARK: - Methods
    
    func change(direction: Direction) {
        model.change(direction: direction)
        model.lockDirection()
    }
    
    func grow() {
        let growLevel = SnakeIncreaseLevel.one.rawValue
        model.increaseLength(by: growLevel)
        let isGrown = resolveGrowing()
        
        assert(isGrown, "Snake has grown for \(growLevel) node(s)")
    }
    
    @discardableResult private func resolveGrowing() -> Bool {
        if model.length > nodes.count, let node = factory.produceRandom(), let lastIncereasedPiece = model.pieces.last {
            node.position = lastIncereasedPiece
            addChild(node)
            nodes += [node]
            return true
        }
        return false
    }
    
    fileprivate func updateNodes() {
        
    }
}

extension SnakeNode: Updatable {
    
    func update() {
        model.move()
        model.unlockDirection()
    }
}
