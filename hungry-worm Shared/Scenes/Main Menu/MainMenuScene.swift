//
//  MainMenuScene.swift
//  hungry-worm
//
//  Created by Astemir Eleev on 04/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    // MARK: - Methods
    
    override func sceneDidLoad() {
        isUserInteractionEnabled = true
    }
    
    #if os(OSX)
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        handleNodeInteraction(for: location)
    }
    
    #endif
    
    #if os(iOS)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = event?.allTouches?.first?.location(in: self) else { return }
        handleNodeInteraction(for: location)
    }
    
    #endif

    // MARK: - Private methods
    
    private func handleNodeInteraction(for location: CGPoint) {
        let nodes = self.nodes(at: location)
        
        let node = nodes.first { (node) -> Bool in
            return node.name?.contains("level") ?? false
        }
        
        guard let unode = node, let levelName = unode.userData?["levelName"] as? String else {
            return
        }
        presentScene(named: levelName)
    }
    
    private func presentScene(named name: String) {
        let scene = GameSceneController.newGameScene(named: name)
        
        // Present the scene
        view?.presentScene(scene, transition: .crossFade(withDuration: 1.0))
        
        view?.ignoresSiblingOrder = true
        view?.showsFPS = true
        view?.showsNodeCount = true
    }
    
}
