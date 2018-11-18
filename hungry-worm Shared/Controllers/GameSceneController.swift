//
//  GameScene.swift
//  snake Shared
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class GameSceneController: SKScene {

    // MARK: - Properties
    
    private var markers: (fruits: [CGPoint], spawnPoints: [CGPoint], timeBombs: [CGPoint]) = ([], [], [])
    private var snake: WormNode?
    private var parser = TileLevel()
    
    fileprivate var fruitGenerator: FruitGenerator!
    private var spawnControllr: SpawnController!
    private var timeBombGenerator: TimeBombGenerator!
    
    lazy fileprivate var physicsContactController: PhysicsContactController = {
        guard let snake = self.snake else {
            fatalError("Could not unwrap the required properties in order to initialize PhysicsContactController class")
        }
        return PhysicsContactController(worm: snake, fruitGenerator: fruitGenerator, timeBombGenerator: timeBombGenerator, scene: self, deathHandler: deathHandler)
    }()
    
    lazy fileprivate var deathHandler: () -> () = { [weak self] in
        self?.snake?.kill()
        self?.snake = nil
        
        let waitAction = SKAction.wait(forDuration: 2)
        let createAction = SKAction.run {
            self?.createWorm()
            self?.physicsContactController.worm = self?.snake
        }
        let respawnActionSequnece = SKAction.sequence([waitAction, createAction])
        self?.run(respawnActionSequnece)
    }
    
    private var timeOfLastMove: TimeInterval = 0
    private(set) var timePerMove = 0.0

    class func newGameScene(named name: String) -> GameSceneController {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: name) as? GameSceneController else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    fileprivate var pauseHudNode: SKNode?
    
    // MARK: - Methods
    
    func setUpScene() {
        #if os(iOS) || os(tvOS)
        prepareSwipeGestureRecognizers()
        #endif
        
        physicsWorld.contactDelegate = self
        
        timePerMove = Double(userData?["timePerMove"] as? Float ?? 0.6)
        
        guard let wallsTileNode = scene?.childNode(withName: "Walls") as? SKTileMapNode, let markerTileNode = scene?.childNode(withName: "Markers") as? SKTileMapNode else {
            fatalError("Could not load Walls or Markers SKTileMapNode, the app cannot be futher executed")
        }
        markers = parser.parseMarkers(for: markerTileNode)

        fruitGenerator = FruitGenerator(spawnPoints: markers.fruits, zPosition: 20)
        timeBombGenerator = TimeBombGenerator(spawnPoints: markers.timeBombs)

        let walls = parser.parseWalls(for: wallsTileNode)
        walls.forEach { self.addChild($0) }
        
        spawnControllr = SpawnController()
        createWorm()
        
        physicsContactController.generateFruit()
        physicsContactController.generateTimeBomb()
    }
    
    override func didMove(to view: SKView) {
        launchReferenceAnimations()
        setUpScene()
        prepareHud()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (currentTime - timeOfLastMove) < timePerMove { return }
        
        snake?.update()
        timeOfLastMove = currentTime
    }
    
    deinit {
        snake?.kill()
        snake = nil
        
        children.forEach { (node) in
            node.removeAllActions()
            node.removeAllChildren()
            node.removeFromParent()
        }
        
        scene?.removeAllActions()
        scene?.removeAllChildren()
        scene?.removeFromParent()
    }
    // MARK: - Utils
    
    func createWorm() {
        let spawnPoint = spawnControllr.generate(outOf: markers.spawnPoints)
        
        snake = WormNode(position: spawnPoint ?? .zero)
        snake?.zPosition = 50
        addChild(snake!)
    }
    
    /// Prepares the HUD layout paddings for a particular scene size
    private func prepareHud() {
        pauseHudNode = scene?.childNode(withName: "//Pause")
        let height = (view?.frame.height ?? 1.0) / 2
        pauseHudNode?.position.y = height + 40
    }
    
    private func handlePauseMenu() {
        // show the pause menu
        
        var scene: SKScene?
        
        #if os(macOS)
        scene = GameViewController.mainMenuScene()
        #elseif os(iOS)
        scene = GameViewController.mainMenuScene()
        #endif
        
        guard let uscene = scene else {
            fatalError("Could not create a SKScene instance for the current platform")
        }
        view?.presentScene(uscene, transition: .doorsCloseVertical(withDuration: 1.0))
    }
}

// Physics Simulation resolution
extension GameSceneController: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        physicsContactController.didBeginPhysicsContact(contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        physicsContactController.didEndPhysicsContact(contact)
    }
}

#if os(iOS) || os(tvOS)
/// Touch-based event handling, iOS & tvOS related setup code
extension GameSceneController {

    // MARK: - Touch handling overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        let pauseNode = nodes(at: location).first { $0.name == pauseHudNode?.name ?? "Pause" }
        
        if let _ = pauseNode {
            handlePauseMenu()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Has not been implemented yet
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Has not been implemented yet
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Has not been implemented yet
    }
   
    // MARK: - Setup
    
    fileprivate func prepareSwipeGestureRecognizers() {
        
        for direction in [UISwipeGestureRecognizer.Direction.right,
                          UISwipeGestureRecognizer.Direction.left,
                          UISwipeGestureRecognizer.Direction.up,
                          UISwipeGestureRecognizer.Direction.down] {
                            
                            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(GameSceneController.swipe(_:)))
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
    static let escape = UInt16(kVK_Escape)
    
    // MARK: - Mouse handling overrides
    
    override func mouseDown(with event: NSEvent) {
        // Has not been implemented yet
        
        let location = event.location(in: self)
        let pauseNode = nodes(at: location).first { $0.name == pauseHudNode?.name ?? "Pause" }
        
        if let _ = pauseNode {
            handlePauseMenu()
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        // Has not been implemented yet
    }
    
    override func mouseUp(with event: NSEvent) {
        // Has not been implemented yet
    }
    
    // MARK: - Keyboard handling
    
    override func keyDown(with event: NSEvent) {
        let keyCode = event.keyCode
        
        switch keyCode {
        case GameScene.leftArrow:
            snake?.change(direction: .left)
        case GameScene.rightArrow:
            snake?.change(direction: .right)
        case GameScene.upArrow:
            snake?.change(direction: .up)
        case GameScene.downArrow:
            snake?.change(direction: .down)
        case GameScene.escape:
            handlePauseMenu()
        default:
            break
        }
    }

}
#endif
