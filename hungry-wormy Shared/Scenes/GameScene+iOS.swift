//
//  GameScene+iOS.swift
//  hungry-worm iOS
//
//  Created by Astemir Eleev on 04/12/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation
import SpriteKit

#if os(iOS) || os(tvOS)
/// Touch-based event handling, iOS & tvOS related setup code
extension GameScene {
    
    // MARK: - Touch handling overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        let pauseNode = nodes(at: location).first { $0.name == pauseHudNode?.name ?? "Pause" }
        
        if let _ = pauseNode {
            toggleOverlayScene(for: .pause, shouldPause: true)
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
    
    func prepareSwipeGestureRecognizers() {
        
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
            wormy?.change(direction: .right)
        case UISwipeGestureRecognizer.Direction.left:
            wormy?.change(direction: .left)
        case UISwipeGestureRecognizer.Direction.up:
            wormy?.change(direction: .up)
        case UISwipeGestureRecognizer.Direction.down:
            wormy?.change(direction: .down)
        default:
            assert(false, "The occured gesture is not supported")
        }
    }
    
}
#endif
