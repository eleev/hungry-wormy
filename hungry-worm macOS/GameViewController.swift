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

    class func mainMenuScene() -> SKScene {
        guard let scene = SKScene(fileNamed: "MainMenuScene-macOS") as? MainMenuScene else {
            print("Failed to load MainMenuScene.sks")
            abort()
        }
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameViewController.mainMenuScene()
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

}

