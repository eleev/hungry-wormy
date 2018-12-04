//
//  ButtonIdentifier.swift
//  hungry-worm
//
//  Created by Astemir Eleev on 04/12/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

/// The complete set of button identifiers supported in the app.
enum ButtonIdentifier: String, CaseIterable {
    case pause = "Pause"
    case resume = "Resume"
    case menu = "Menu"
    
    // The code is not used right now, but needs to be reviewed before publishing
    //    case play = "Play"
    //    case home = "Home"
    //    case settings = "Settings"
    //    case retry = "Retry"
    //    case cancel = "Cancel"
    //    case scores = "Scores"
    //    case sound = "Sound"
    //    case characters = "Characters"
    //    case difficulty = "Difficulty"
    
    /// The name of the texture to use for a button when the button is selected.
    var selectedTextureName: String? {
        switch self {
        default:
            return nil
        }
    }
}
