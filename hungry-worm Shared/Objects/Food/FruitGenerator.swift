//
//  FruitGenerator.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

struct FruitGenerator {
    
    // MARK: - Properties
    
    private var spawnPoints: [CGPoint]
    private let zPosition: CGFloat
    private var lastFruit: FoodNode?
    
    // MARK: - Initializers
    
    init(spawnPoints: [CGPoint], zPosition: CGFloat) {
        self.spawnPoints = spawnPoints
        self.zPosition = zPosition
    }
    
    // MARK: - Methods
    
    mutating func generate() -> FoodNode {
        let randomFood = FoodType.allCases.randomElement() ?? FoodType.bee
        
        let index = Int.random(in: 0..<spawnPoints.count)
        let point = spawnPoints.remove(at: index)
        
        let node = FoodNode(position: point, zPosition: zPosition, type: randomFood)
        lastFruit = node
        return node
    }
    
    func removeLastFruit() {
        lastFruit?.remove()
    }
    
    func isDrained() -> Bool {
        return spawnPoints.isEmpty
    }
}
