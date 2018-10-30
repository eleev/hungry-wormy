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
    
    // MARK: - Initializsers
    
    init(position: CGPoint) {
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
    
    func change(direction: Direction) {
        self.direction = direction
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
