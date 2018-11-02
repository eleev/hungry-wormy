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
    
    private var markers: (fruits: [CGPoint], spawnPoints: [CGPoint]) = ([], [])
    private var snake: WormNode?
    private var parser = TileLevel()
    fileprivate var fruitGenerator: FruitGenerator!
    private var spawnControllr: SpawnController!
    
    lazy fileprivate var physicsContactController: PhysicsContactController = {
        guard let snake = self.snake else {
            fatalError("Could not unwrap the required properties in order to initialize PhysicsContactController class")
        }
        return PhysicsContactController(worm: snake, fruitGenerator: fruitGenerator, scene: self, deathHandler: deathHandler)
    }()
    
    lazy fileprivate var deathHandler: () -> () = { [weak self] in
        self?.snake?.kill()
        self?.snake = nil
        
        let waitAction = SKAction.wait(forDuration: 2)
        let createAction = SKAction.run {
            self?.createWorm()
        }
        let respawnActionSequnece = SKAction.sequence([waitAction, createAction])
        self?.run(respawnActionSequnece)
    }
    
    private var timeOfLastMove: TimeInterval = 0
    let timePerMove = 0.4

    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "DemoLevel-16x16") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit
        
        return scene
    }
    
    // MARK: - Methods
    
    func setUpScene() {
        #if os(iOS) || os(tvOS)
        prepareSiwpeGestureRecognizers()
        #endif
        
        physicsWorld.contactDelegate = self
        
        guard let wallsTileNode = scene?.childNode(withName: "Walls") as? SKTileMapNode, let markerTileNode = scene?.childNode(withName: "Markers") as? SKTileMapNode else {
            fatalError("Could not load Walls or Markers SKTileMapNode, the app cannot be futher executed")
        }
        print("markerTileNode.numberOfRows: ", markerTileNode.numberOfRows, " markerTileNode.numberOfColumns", markerTileNode.numberOfColumns)
        
        markers = parser.parseMarkers(for: markerTileNode)
        fruitGenerator = FruitGenerator(spawnPoints: markers.fruits, zPosition: 20)
        
        let walls = parser.parseWalls(for: wallsTileNode)
        walls.forEach { self.addChild($0) }
        

        spawnControllr = SpawnController()
        createWorm()
        
        physicsContactController.generateFruit()
    }
    
    override func didMove(to view: SKView) {
        setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if (currentTime - timeOfLastMove) < timePerMove {
            return
        }
        
        snake?.update()
        
        timeOfLastMove = currentTime
    }
    
    // MARK: - Utils
    
    func createWorm() {
        let spawnPoint = spawnControllr.generate(outOf: markers.spawnPoints)
        
        snake = WormNode(position: spawnPoint ?? .zero)
        snake?.zPosition = 50
        addChild(snake!)
    }
}

// Physics Simulation resolution
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        physicsContactController.didBeginPhysicsContact(contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        physicsContactController.didEndPhysicsContact(contact)
    }
}

#if os(iOS) || os(tvOS)
/// Touch-based event handling, iOS & tvOS related setup code
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
   
    // MARK: - Setup
    
    fileprivate func prepareSiwpeGestureRecognizers() {
        
        for direction in [UISwipeGestureRecognizer.Direction.right,
                          UISwipeGestureRecognizer.Direction.left,
                          UISwipeGestureRecognizer.Direction.up,
                          UISwipeGestureRecognizer.Direction.down] {
                            
                            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipe(_:)))
                            gesture.direction = direction
                            view?.addGestureRecognizer(gesture)
        }
        
    }
    
    @objc func swipe(_ gr: UISwipeGestureRecognizer) {
        let direction = gr.direction
        
        switch direction {
        case UISwipeGestureRecognizer.Direction.right:
            snake?.change(direction: .right)
        case UISwipeGestureRecognizer.Direction.left:
            snake?.change(direction: .left)
        case UISwipeGestureRecognizer.Direction.up:
            snake?.change(direction: .up)
        case UISwipeGestureRecognizer.Direction.down:
            snake?.change(direction: .down)
        default:
            assert(false, "The occured gesture is not supported")
        }
    }
    
}
#endif

#if os(OSX)

import Carbon

/// Mouse-based event handling
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

