//
//  WormNode.swift
//  snake
//
//  Created by Astemir Eleev on 25/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit
#if os(iOS)
import UIKit
#endif

class WormNode: SKNode {
    
    // MARK: - Properties
    
    private let factory: WormNodeFactory
    private var nodes: [WormPartNode] = []
    
    var lenght: Int {
        return nodes.count
    }
    
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
    
    #if os(iOS)
    private var impactGenerator = UIImpactFeedbackGenerator(style: .light)
    #endif
    
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
    
    @discardableResult func change(direction: Direction) -> Bool {
        // Will ignore impossible direction changes e.g. changing direction for 180 degrees (current is `up` and attempting to change to `down`)
        if self.direction.isAbleToSwitch(toNew: direction) {
            #if os(iOS)
            impactGenerator.impactOccurred()
            #endif
            self.direction = direction
            return true
        }
        return false
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
    
    func split(at wormNode: WormPartNode, completion: @escaping (_ hasAdded: Bool) -> () = { bool in }) {
        // Prevent +2 split calls to concurrently modify one non atomic data structure
        DispatchQueue.main.async(flags: .barrier) { [weak self] in
            var indexToRemove: Int = -1
            
            guard let nodes = self?.nodes else {
                completion(false)
                return
            }
            let nodesCount = nodes.count - 1
            
            for (index, node) in nodes.enumerated() where node === wormNode {
                var slice = nodes[index..<nodesCount]
                indexToRemove = index
                
                for sliceNode in slice {
                    sliceNode.removeAllActions()
                    sliceNode.removeFromParent()
                }
                slice.removeAll()
                
                break
            }
            let shouldResetTail = indexToRemove != -1
            
            if shouldResetTail {
                self?.nodes.removeSubrange(indexToRemove..<nodesCount)
                self?.resetTailNode()
            }
            completion(shouldResetTail)
        }
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
    
    private func resetTailNode() {
        tail.position = initialPosition
        tail.position.y -= 32
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
