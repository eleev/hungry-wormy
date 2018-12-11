//
//  SceneOverlay.swift
//  hungry-worm iOS
//
//  Created by Astemir Eleev on 03/12/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class SceneOverlay {
    
    // MARK: Properties
    
    let backgroundNode: SKSpriteNode
    let contentNode: SKSpriteNode
    
    // MARK: Intialization
    
    init(overlaySceneFileName fileName: String, zPosition: CGFloat) {
        // Load the scene and get the overlay node from it.
        let overlayScene = SKScene(fileNamed: fileName)!
        let contentTemplateNode = overlayScene.childNode(withName: "Overlay") as! SKSpriteNode
        
        var scale: CGFloat = 1.0
        #if os(iOS)
        scale = UIScreen.main.scale
        #endif
        
        // Create a background node with the same color as the template.
        backgroundNode = SKSpriteNode(color: contentTemplateNode.color, size: contentTemplateNode.size * scale)
        backgroundNode.zPosition = zPosition
        
        // Copy the template node into the background node.
        contentNode = contentTemplateNode.copy() as! SKSpriteNode
        contentNode.position = .zero
        backgroundNode.addChild(contentNode)
        
        // Set the content node to a clear color to allow the background node to be seen through it.
        contentNode.color = .clear
    }
}
