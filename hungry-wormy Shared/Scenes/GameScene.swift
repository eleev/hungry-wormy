//
//  GameScene.swift
//  snake Shared
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class GameScene: RoutingUtilityScene {

    // MARK: - Properties
    
    private(set) var lastOverlayType: OverlayType?
    
    /// The current scene overlay (if any) that is displayed over this scene.
    private var overlay: SceneOverlay? {
        didSet {
            // Clear the `buttons` in preparation for new buttons in the overlay.
            pauseHudNode?.run(SKAction.hide())
            
            // Animate the old overlay out.
            oldValue?.backgroundNode.run(SKAction.fadeOut(withDuration: 0.25)) {
                debugPrint(#function + " remove old overlay")
                oldValue?.backgroundNode.removeFromParent()
            }
            
            if let overlay = overlay, let scene = scene {
                debugPrint(#function + " added overaly")
                overlay.backgroundNode.removeFromParent()
                scene.addChild(overlay.backgroundNode)
                
                // Animate the overlay in.
                overlay.backgroundNode.alpha = 1.0
                overlay.backgroundNode.run(SKAction.fadeIn(withDuration: 0.25))
                
                pauseHudNode?.run(SKAction.unhide())
            }
        }
    }
    
    private var markers: (fruits: [CGPoint], spawnPoints: [CGPoint], timeBombs: [CGPoint]) = ([], [], [])
    private(set) var wormy: WormNode?
    private var parser = TileLevel()
    
    fileprivate var fruitGenerator: FruitGenerator!
    private var spawnControllr: SpawnController!
    private var timeBombGenerator: TimeBombGenerator!
    
    lazy fileprivate var physicsContactController: PhysicsContactController = {
        guard let snake = self.wormy else {
            fatalError("Could not unwrap the required properties in order to initialize PhysicsContactController class")
        }
        return PhysicsContactController(worm: snake, fruitGenerator: fruitGenerator, timeBombGenerator: timeBombGenerator, scene: self, deathHandler: deathHandler)
    }()
    
    lazy fileprivate var deathHandler: () -> () = { [weak self] in
        self?.wormy?.kill()
        self?.physicsContactController.worm = nil
        self?.wormy = nil
        
        self?.physicsWorld.contactDelegate = nil
        self?.toggleOverlayScene(for: .death)
    }
    
    lazy fileprivate var restartHandler: ()->() = { [ weak self ] in
        self?.createWorm()
        self?.physicsContactController.worm = self?.wormy
    }
    
    private var timeOfLastMove: TimeInterval = 0
    private(set) var timePerMove = 0.0

    class func newGameScene(named name: String) -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: name) as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    var pauseHudNode: SKNode?
    
    // MARK: - Methods
    
    func setUpScene() {
        #if os(iOS) || os(tvOS)
        prepareSwipeGestureRecognizers()
        #endif
        
        pauseToggleDelegate = self
        restartToggleDelegate = self
        
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
        
        #if (iOS) || os(tvOS)
        prepareHud()
        #endif
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (currentTime - timeOfLastMove) < timePerMove { return }
        
        wormy?.update()
        timeOfLastMove = currentTime
    }
    
    deinit {
        wormy?.kill()
        wormy = nil
        
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
        
        wormy = WormNode(position: spawnPoint ?? .zero)
        wormy?.zPosition = 50
        addChild(wormy!)
        
        physicsWorld.contactDelegate = self
    }
    
    /// Prepares the HUD layout paddings for a particular scene size
    private func prepareHud() {
        pauseHudNode = scene?.childNode(withName: "//Pause")
        let height = (view?.frame.height ?? 1.0)
        pauseHudNode?.position.y = height - 40
        pauseHudNode?.position.x -= 48
    }
    
    func toggleOverlayScene(for overlay: OverlayType, shouldPause: Bool = false) {
        debugPrint(#function)
        
        lastOverlayType = overlay
        
        if let _ = self.overlay {
            if shouldPause {
                self.isPaused = false
            }
            self.overlay = nil
            return
        }
        
        if shouldPause {
            self.isPaused = true
        }

        let overlay = SceneOverlay(overlaySceneFileName: overlay.sceneName, zPosition: 1000)
        self.overlay = overlay
    }
}

// MARK: - Conformance to SKPhysicsContactDelegate protocol
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        physicsContactController.didBeginPhysicsContact(contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        physicsContactController.didEndPhysicsContact(contact)
    }
}

// MARK: - Conformance to PauseTogglable protocol
extension GameScene: PauseTogglable {
    func didTogglePause() {
        toggleOverlayScene(for: .pause, shouldPause: true)
    }
}

// MARK: - Conformance to Restarable protocol
extension GameScene: Restarable {
    
    var sceneToRestart: String {
        return (scene?.name)! 
    }
}
