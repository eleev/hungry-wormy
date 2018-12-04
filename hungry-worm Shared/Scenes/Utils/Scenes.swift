//
//  Scenes.swift
//  hungry-worm
//
//  Created by Astemir Eleev on 19/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

enum Scenes: String {
    case main = "MainMenuScene"
    case game = "GameScene"
    case pause = "PauseMenuScene"
    
    // The code is not used right now, but needs to be reviewed before publishing
//    case setting = "SettingsScene"
//    case score = "ScoreScene"
//    case pause = "PauseScene"
//    case failed = "FailedScene"
//    case characters = "CharactersScene"
}

extension Scenes {
    func getName() -> String {
        #if os(iOS)
        
        // The code is not used right now, but needs to be reviewed before publishing
//        let padId = " iPad"
//        let isPad = UIDevice.current.userInterfaceIdiom == .pad
//        return isPad ? self.rawValue + padId : self.rawValue
        return rawValue + "-iOS"
        
        #elseif os(macOS)
        
        return rawValue + "-macOS"
        
        #endif
    }

}
