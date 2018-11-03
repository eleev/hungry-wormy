//
//  WormNode.swift
//  snake
//
//  Created by Astemir Eleev on 25/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class WormNode: SKNode {
    
    // MARK: - Properties
    
    private let factory: WormNodeFactory
    private var nodes: [WormPartNode] = []
    
    private var direction: Direction = .none {
        didSet {
            head.direction = direction
        }
    }
    private var lastStateSwitchTime: CFTimeInterval = 0
    
    private var initialPosition: CGPoint
    private lazy var head: WormHeadNode = {
        let head = factory.produceHead()
        head.zPosition = 50
        
        head.position = initialPosition
        nodes += [head]
        return head
    }()
    private lazy var tail: SnakeTailNode = {
        let tail = factory.produceTail()
        tail.zPosition = 49
        
        tail.position = initialPosition
        tail.position.y -= 32
        nodes += [tail]
        return tail
    }()
    
    let SIZE = 64
    var CGSIZE: CGFloat {
        return CGFloat(SIZE)
    }
    private var isAboutToBeKilled = false

    // MARK: - Initializsers
    
    init(position: CGPoint) {
        isAboutToBeKilled = false
        factory = WormNodeFactory(nodeSize: SIZE, zPosition: 50)
        initialPosition = position
        
        super.init()
        
        addChild(head)
        addChild(tail)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Could not create an instance of SnakeNode class")
    }
    
    // MARK: - Methods
    
    func kill() {
        isAboutToBeKilled = true
        
        nodes.forEach { $0.removeFromParent() }
        nodes.removeAll()
        head.removeFromParent()
        tail.removeFromParent()
        removeAllActions()
        removeFromParent()
    }
    
    func move() {
        
        if nodes.count == 1 {
            let node = nodes[0]
            var newHeadNodePosition: CGPoint = node.position

            newHeadNodePosition = resolveSize(initialPosition: newHeadNodePosition)
            node.position = newHeadNodePosition
            
            return
        }
        
        for index in (1..<nodes.count).reversed() {
            let node = nodes[index - 1]
            let oldHeadNodePosition = node.position
            var newHeadNodePosition: CGPoint = oldHeadNodePosition
            
            let nextNode = nodes[index]
            newHeadNodePosition = resolveSize(initialPosition: newHeadNodePosition)

            node.position = newHeadNodePosition
            nextNode.position = oldHeadNodePosition
        }
    }
    
    func change(direction: Direction) {
        self.direction = direction
    }
    
    private func resolveSize(initialPosition: CGPoint, shouldInverse: Bool = false) -> CGPoint {
        var position = initialPosition
        
        switch direction {
        case .left:
            position.x = shouldInverse ? position.x + CGSIZE : position.x - CGSIZE
        case .right:
            position.x = shouldInverse ? position.x - CGSIZE : position.x + CGSIZE
        case .up:
            position.y = shouldInverse ? position.y - CGSIZE : position.y + CGSIZE
        case .down:
            position.y = shouldInverse ? position.y + CGSIZE : position.y - CGSIZE
        case .none:
            return position
        }
        return position
    }
    
    
    func grow(for level: WormIncreaseLevel = .one) {
        var growLevel = level.rawValue
        
        while growLevel != 0 {
            let node = factory.produceBody()
            node.alpha = 0.0
            
            // Store the last, tail node for later use
            let lastNode = nodes.removeLast() as? SnakeTailNode
            lastNode?.removeFromParent()
            
            var lastPosition = nodes.last?.position ?? node.position
            lastPosition = resolveSize(initialPosition: lastPosition, shouldInverse: true)

            node.position = lastPosition
            node.zRotation = direction.toRotationDegrees().toRadians
            
            nodes += [node]
            addChild(node)
            
            node.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeAlpha(to: 1.0, duration: 1.0)]))
            
            if let tailNode = lastNode {
                nodes += [tailNode]
                self.tail = tailNode
                addChild(tailNode)
            }
            
            growLevel -= 1
        }
    }
}

extension WormNode: Updatable {
    
    func update() {
        // If the worm is about to be killed ingnore the update loop updates
        if isAboutToBeKilled { return }
        
        move()
        head.update()

        // Resolved the orientation of the tail of the worm
        if let prelastNode = nodes.dropLast().last, let last = nodes.last {
            let position = prelastNode.position
            let tailPosition = last.position
            let diff = tailPosition - position
            
            switch (diff.x, diff.y) {
            case (let x, _) where x < 0:
                tail.direction = .right
            case (let x, _) where x > 0:
                tail.direction = .left
            case (_, let y) where y < 0:
                tail.direction = .up
            case (_, let y) where y > 0:
                tail.direction = .down
            default:
                tail.direction = head.direction
            }
        }
        
        tail.update()
    }
}
