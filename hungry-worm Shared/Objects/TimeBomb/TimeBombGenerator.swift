//
//  TimeBombGenerator.swift
//  hungry-worm
//
//  Created by Astemir Eleev on 12/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

struct TimeBombGenerator {
    
    // MARK: - Properties
    
    private var spawnPoints: [CGPoint]
    private var lastBomb: TimeBombNode?
    
    // MARK: - Initializers
    
    init(spawnPoints: [CGPoint]) {
        self.spawnPoints = spawnPoints
    }
    
    // MARK: - Methods
    
    mutating func generate() -> TimeBombNode? {
        if spawnPoints.isEmpty { return lastBomb }
        let index = Int.random(in: 0..<spawnPoints.count)
        let point = spawnPoints.remove(at: index)
        
        let node = TimeBombNode(position: point)
        lastBomb = node
        
        return node
    }
    
    func removeLast() {
        lastBomb?.remove()
    }
    
    func isDrained() -> Bool {
        return spawnPoints.isEmpty
    }
}
