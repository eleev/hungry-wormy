//
//  TileLevel.swift
//  snake
//
//  Created by Astemir Eleev on 25/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class TileLevel {
    
    // MARK: - Properties
    
    private(set) var width: Int = 0
    private(set) var height: Int = 0
    private(set) var startPosition: CGPoint = .zero
    
    // MARK: - Methods
    
    func parseWalls(for tileMapNode: SKTileMapNode) -> [SKSpriteNode] {
        width = tileMapNode.numberOfColumns
        height = tileMapNode.numberOfRows
        
        let zPosition = tileMapNode.zPosition
        var nodes = [SKSpriteNode]()
        
        for i in 0..<tileMapNode.numberOfRows {
            for j in 0..<tileMapNode.numberOfColumns {
                guard let tileDef = tileMapNode.tileDefinition(atColumn: i, row: j) else {
                    continue
                }
                var nodePosition = CGPoint(x: CGFloat(i) * tileMapNode.tileSize.width - tileMapNode.mapSize.width / 2, y: CGFloat(j) * tileMapNode.tileSize.height - tileMapNode.mapSize.height / 2)
                nodePosition.x += tileDef.size.width / 2
                nodePosition.y += tileDef.size.height / 2
                
                let size = tileDef.size
                let texture = tileDef.textures[0]
                
                let node = SKSpriteNode(texture: texture, size: size)
                node.position = nodePosition
                node.zPosition = zPosition
                node.physicsBody = SKPhysicsBody(rectangleOf: size)
                node.physicsBody?.isDynamic = false
                node.physicsBody?.isResting = true
                node.physicsBody?.affectedByGravity = false
                node.physicsBody?.categoryBitMask = PhysicsTypes.wall.rawValue
                node.physicsBody?.contactTestBitMask = PhysicsTypes.snake.rawValue
                
                nodes += [node]
            }
        }
        tileMapNode.removeFromParent()
        return nodes
    }
    
    func parseMarkers(for tileMapNode: SKTileMapNode) -> (fruits: [CGPoint], spawnPoints: [CGPoint]) {
     
        var fruits = [CGPoint]()
        var spawnPoints = [CGPoint]()
        
        for i in 0..<tileMapNode.numberOfRows {
            for j in 0..<tileMapNode.numberOfColumns {
                guard let tileDef = tileMapNode.tileDefinition(atColumn: i, row: j) else {
                    continue
                }
                
                var nodePosition = CGPoint(x: CGFloat(i) * tileMapNode.tileSize.width - tileMapNode.mapSize.width / 2, y: CGFloat(j) * tileMapNode.tileSize.height - tileMapNode.mapSize.height / 2)
                nodePosition.x += tileDef.size.width / 2
                nodePosition.y += tileDef.size.height / 2
                
                if tileDef.name == "Food" {
                    fruits += [nodePosition]
                } else if tileDef.name == "Player Spawn Point" {
                    spawnPoints += [nodePosition]
                }
            }
        }
        tileMapNode.removeFromParent()
        return (fruits: fruits, spawnPoints: spawnPoints)
    }
}
