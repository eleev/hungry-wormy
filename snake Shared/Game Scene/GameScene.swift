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
        guard let wallsTileNode = scene?.childNode(withName: "Walls") as? SKTileMapNode else {
            fatalError("Could not load Walls SKTileMapNode, the app cannot be futher executed")
        }
        
        let walls = parser.parseWalls(for: wallsTileNode)
        walls.forEach { self.addChild($0) }
        
        
        
        snake = SnakeNode(position: .zero, worldSize: 24, initial: .up)
        snake?.zPosition = 50
        addChild(snake!)
    }
    
    override func didMove(to view: SKView) {
        setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
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

