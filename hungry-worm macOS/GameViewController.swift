//
//  GameViewController.swift
//  snake macOS
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let scene = SKScene(fileNamed: "MainMenuScene") as? MainMenuScene else {
            print("Failed to load MainMenuScene.sks")
            abort()
        }
        scene.scaleMode = .aspectFit
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

}

