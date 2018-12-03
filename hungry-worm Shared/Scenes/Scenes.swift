//
//  Scenes.swift
//  hungry-worm
//
//  Created by Astemir Eleev on 19/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

enum Scenes: String {
    case main = "MainMenuScene"
    case game = "GameScene"
    case pause = "PauseMenuScene"
//    case setting = "SettingsScene"
//    case score = "ScoreScene"
//    case pause = "PauseScene"
//    case failed = "FailedScene"
//    case characters = "CharactersScene"
}

extension Scenes {
    func getName() -> String {
        #if os(iOS)
        
//        let padId = " iPad"
//        let isPad = UIDevice.current.userInterfaceIdiom == .pad
//        return isPad ? self.rawValue + padId : self.rawValue
        return rawValue + "-iOS"
        
        #elseif os(macOS)
        
        return rawValue + "-macOS"
        
        #endif
    }
}


/// The complete set of button identifiers supported in the app.
enum ButtonIdentifier: String, CaseIterable {
    case play = "Play"
    case pause = "Pause"
    case resume = "Resume"
    case menu = "Menu"
    case home = "Home"
    case settings = "Settings"
    case retry = "Retry"
    case cancel = "Cancel"
    case scores = "Scores"
    case sound = "Sound"
    case characters = "Characters"
    case difficulty = "Difficulty"
    
    /// The name of the texture to use for a button when the button is selected.
    var selectedTextureName: String? {
        switch self {
        default:
            return nil
        }
    }
}

import simd

enum ControlInputDirection: Int {
    case up = 0, down, left, right
    
    init?(vector: float2) {
        // Require sufficient displacement to specify direction.
        guard length(vector) >= 0.5 else { return nil }
        
        // Take the max displacement as the specified axis.
        if abs(vector.x) > abs(vector.y) {
            self = vector.x > 0 ? .right : .left
        }
        else {
            self = vector.y > 0 ? .up : .down
        }
    }
}
