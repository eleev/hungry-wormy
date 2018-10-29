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
    private var nodes: [SnakePartNode] = []
    private var direction: Direction = .none
    private var head: SnakeHeadNode?
    private var tail: SnakeTailNode?
    
    let SIZE = 64
    var CGSIZE: CGFloat {
        return CGFloat(SIZE)
    }
    
    // MARK: - Initializsers
    
    init(position: CGPoint, worldSize: WorldSize, initial direction: Direction) {
        factory = SnakeNodeFactory(nodeSize: SIZE, zPosition: 50)
        
        super.init()
        
        head = factory.produceHead()
        head?.zPosition = 50
        
        head?.position = position
        nodes += [head!]
        addChild(head!)
        
//        let node = factory.produceRandom() ?? factory.produce(from: .chicken)
//        node.position = position
//        nodes += [node]
//        addChild(node)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Could not create an instance of SnakeNode class")
    }
    
    // MARK: - Methods
    
    func move() {
        
        if nodes.count == 1 {
            let node = nodes[0]
            var newHeadNodePosition: CGPoint = node.position

            switch direction {
            case .left:
                newHeadNodePosition.x -= CGSIZE
            case .right:
                newHeadNodePosition.x += CGSIZE
            case .up:
                newHeadNodePosition.y += CGSIZE
            case .down:
                newHeadNodePosition.y -= CGSIZE
            case .none:
                return
            }
            node.position = newHeadNodePosition
            
            return
        }
        
        
        for index in (1..<nodes.count).reversed() {
            let node = nodes[index - 1]
            let oldHeadNodePosition = node.position
            var newHeadNodePosition: CGPoint = oldHeadNodePosition
            
            let nextNode = nodes[index]

            switch direction {
            case .left:
                newHeadNodePosition.x -= CGSIZE
            case .right:
                newHeadNodePosition.x += CGSIZE
            case .up:
                newHeadNodePosition.y += CGSIZE
            case .down:
                newHeadNodePosition.y -= CGSIZE
            case .none:
                continue
            }
            node.position = newHeadNodePosition
            nextNode.position = oldHeadNodePosition
        }
    }
    
    var nextDirection: Direction?
    
    private func directionHandler() {
        guard let nextDirection = nextDirection else {
            return
        }
        switch nextDirection {
        case .left, .right:
            if Int(nodes[0].position.x) % 32 == 0 {
                direction = nextDirection
                self.nextDirection = nil
            }
        case .up, .down:
            if Int(nodes[0].position.y) % 32 == 0 {
                direction = nextDirection
                self.nextDirection = nil
            }
        case .none:
            self.nextDirection = nil
        }
        
    }
    
    func change(direction: Direction) {
        self.direction = direction
        head?.direction = direction
    }
    
    func grow(for level: SnakeIncreaseLevel = .one) {
        var growLevel = level.rawValue
        
        while growLevel != 0 {
            let node = factory.produceBody()
            node.alpha = 0.0
            var lastPosition = nodes.last?.position ?? node.position
            
            //            let node = factory.produceRandom() ?? factory.produce(from: .chicken)
            //            var lastPositon = (nodes.last?.position)!
            
            switch direction {
            case .left:
                lastPosition.x += CGSIZE
            case .right:
                lastPosition.x -= CGSIZE
            case .up:
                lastPosition.y += CGSIZE
            case .down:
                lastPosition.y -= CGSIZE
            case .none:
                break
            }
            node.position = lastPosition
            node.zRotation = direction.toRotationDegrees().toRadians
            
            nodes += [node]
            addChild(node)
            
            node.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeAlpha(to: 1.0, duration: 1.0)]))
            
            growLevel -= 1
        }
    }
}

extension SnakeNode: Updatable {
    
    func update() {
        move()
        head?.update()
    }
}
