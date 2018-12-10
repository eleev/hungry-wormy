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
    case death = "DeathMenuScene"
    case results = "ResultsMenuScene"
}

extension Scenes {
    func getName() -> String {
        #if os(iOS)
        return rawValue + "-iOS"
        #elseif os(macOS)
        return rawValue + "-macOS"
        #endif
    }

}
