//
//  GameViewController.swift
//  snake iOS
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    class func mainMenuScene() -> SKScene {
        guard let scene = SKScene(fileNamed: "MainMenuScene-iOS") as? MainMenuScene else {
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
        
        skView.showsPhysics = false
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
