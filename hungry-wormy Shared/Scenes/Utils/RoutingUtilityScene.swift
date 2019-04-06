//
//  RoutingUtilityScene.swift
//  hungry-worm
//
//  Created by Astemir Eleev on 19/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

class RoutingUtilityScene: SKScene, ButtonNodeResponderType {
    
    // MARK: - Properties
    
    weak var pauseToggleDelegate: PauseTogglable?
    weak var restartToggleDelegate: Restarable?
    
    #if os(iOS)
    let selection = UISelectionFeedbackGenerator()
    #endif

    static let sceneScaleMode: SKSceneScaleMode = .aspectFill
    private static var lastPushTransitionDirection: SKTransitionDirection?
    
    
    // MARK: - Conformance to ButtonNodeResponderType
    
    func buttonTriggered(button: ButtonNode) {
        guard let identifier = button.buttonIdentifier else {
            return
        }
        #if os(iOS)
        selection.selectionChanged()
        #endif
        
        var sceneToPresent: SKScene?
        var transition: SKTransition?
        let sceneScaleMode: SKSceneScaleMode = RoutingUtilityScene.sceneScaleMode
        
        switch identifier {
        case .restart:
            guard let sceneName = restartToggleDelegate?.sceneToRestart else {
                fatalError("Could not unwrap the scene name")
            }
            sceneToPresent = GameScene.newGameScene(named: sceneName)
            sceneToPresent?.name = sceneName
            transition = SKTransition.crossFade(withDuration: 1.5)
        case .resume:
            pauseToggleDelegate?.didTogglePause()
        case .menu:
            let sceneId = Scenes.main.getName()
            sceneToPresent = MainMenuScene(fileNamed: sceneId)
            
            var pushDirection: SKTransitionDirection?
            
            if let lastPushTransitionDirection = RoutingUtilityScene.lastPushTransitionDirection {
                switch lastPushTransitionDirection {
                case .up:
                    pushDirection = .down
                case .down:
                    pushDirection = .up
                case .left:
                    pushDirection = .right
                case .right:
                    pushDirection = .left
                @unknown default:
                    fatalError("The trnasition direction is unknown. Please review the latest changes of the API or contact the author to resolve the issue.")
                }
                RoutingUtilityScene.lastPushTransitionDirection = pushDirection
            }
            if let pushDirection = pushDirection {
                transition = SKTransition.push(with: pushDirection, duration: 1.0)
            } else {
                transition = SKTransition.fade(withDuration: 1.0)
            }
        default:
            debugPrint(#function + "triggered button node action that is not supported by the TitleScene class")
        }
        
        guard let presentationScene = sceneToPresent, let unwrappedTransition = transition  else {
            return
        }
        
        presentationScene.scaleMode = sceneScaleMode
        unwrappedTransition.pausesIncomingScene = false
        unwrappedTransition.pausesOutgoingScene = false
        self.view?.presentScene(presentationScene, transition: unwrappedTransition)
    }
}
