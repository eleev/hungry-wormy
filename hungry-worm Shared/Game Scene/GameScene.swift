//
//  GameScene.swift
//  snake Shared
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    // MARK: - Properties
    
    private var snake: WormNode?
    private var parser = TileLevel()
    fileprivate var fruitGenerator: FruitGenerator!
    private var spawnControllr: SpawnController!
    
    private var timeOfLastMove: TimeInterval = 0
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit
        
        return scene
    }
    
    // MARK: - Methods
    
    func setUpScene() {
        
        physicsWorld.contactDelegate = self
        
        guard let wallsTileNode = scene?.childNode(withName: "Walls") as? SKTileMapNode, let markerTileNode = scene?.childNode(withName: "Markers") as? SKTileMapNode else {
            fatalError("Could not load Walls or Markers SKTileMapNode, the app cannot be futher executed")
        }
        print("markerTileNode.numberOfRows: ", markerTileNode.numberOfRows, " markerTileNode.numberOfColumns", markerTileNode.numberOfColumns)
        
        let markers = parser.parseMarkers(for: markerTileNode)
        fruitGenerator = FruitGenerator(spawnPoints: markers.fruits, zPosition: 20)
        let fruitNode = fruitGenerator.generate()
        addChild(fruitNode)
        
        let walls = parser.parseWalls(for: wallsTileNode)
        walls.forEach { self.addChild($0) }
        

        spawnControllr = SpawnController()
        let spawnPoint = spawnControllr.generate(outOf: markers.spawnPoints)
        
        snake = WormNode(position: spawnPoint ?? .zero)
        snake?.zPosition = 50
        addChild(snake!)        
    }
    
    override func didMove(to view: SKView) {
        setUpScene()
    }
    
    let timePerMove = 0.3
    
    override func update(_ currentTime: TimeInterval) {
        
        if (currentTime - timeOfLastMove) < timePerMove {
            return
        }
        
        snake?.update()
        
        timeOfLastMove = currentTime
    }
}

// Physics Simulation resolution
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
//        let bodyA = contact.bodyA.node?.name
//        let bodyB = contact.bodyB.node?.name
//
        if contact.bodyA.node is FoodNode, contact.bodyB.node is WormPartNode {
            debugPrint("body a is fruit & body b is snake")
            
            fruitGenerator.removeLastFruit()
            let newFruit = fruitGenerator.generate()
            addChild(newFruit)
            
//            let wait = SKAction.wait(forDuration: 1.0)
//            let grow = SKAction.run { self.snake?.grow() }
//            snake?.run(SKAction.sequence([wait, grow]))
            snake?.grow()
        } else if contact.bodyA.node is WormPartNode, contact.bodyB.node is FoodNode {
            debugPrint("body a is snake & body b is fruitr")
            
            fruitGenerator.removeLastFruit()
            let newFruit = fruitGenerator.generate()
            addChild(newFruit)
            
//            let wait = SKAction.wait(forDuration: 1.0)
//            let grow = SKAction.run { self.snake?.grow() }
//            snake?.run(SKAction.sequence([wait, grow]))
            snake?.grow()
        }
        
//        debugPrint("bodyA: ", bodyA, " bodyB: ", bodyB)
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
   
}
#endif

#if os(OSX)

import Carbon

// Mouse-based event handling
extension GameScene {

    // MARK: - Properties
    
    static let downArrow = UInt16(kVK_DownArrow)
    static let leftArrow = UInt16(kVK_LeftArrow)
    static let rightArrow = UInt16(kVK_RightArrow)
    static let upArrow = UInt16(kVK_UpArrow)
    static let backSpace = UInt16(kVK_Space)
    
    // MARK: - Mouse handling
    
    override func mouseDown(with event: NSEvent) {
    }
    
    override func mouseDragged(with event: NSEvent) {
    }
    
    override func mouseUp(with event: NSEvent) {
    }
    
    // MARK: - Keyboard handling
    
    override func keyDown(with event: NSEvent) {
        let keyCode = event.keyCode
        print("changed movement direction to")
        
        if keyCode == GameScene.leftArrow {
            print("left")
            snake?.change(direction: .left)
        }
        
        if keyCode == GameScene.rightArrow {
            print("right")
            snake?.change(direction: .right)
        }
        
        if keyCode == GameScene.upArrow {
            print("up")
            snake?.change(direction: .up)
        }
        
        if keyCode == GameScene.downArrow {
            print("down")
            snake?.change(direction: .down)
        }
    }

}
#endif

