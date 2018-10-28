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
    
    private var snake: SnakeNode?
    private var parser = TileLevel()
    private var fruitGenerator: FruitGenerator!
    private var spawnControllr: SpawnController!
    
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
        
        snake = SnakeNode(position: spawnPoint!, worldSize: 24, initial: .up)
        snake?.zPosition = 50
        addChild(snake!)        
    }
    
    override func didMove(to view: SKView) {
        setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        snake?.update()
    }
}

// Physics Simulation resolution
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
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
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
    }
    
    override func mouseDragged(with event: NSEvent) {
    }
    
    override func mouseUp(with event: NSEvent) {
    }

}
#endif

