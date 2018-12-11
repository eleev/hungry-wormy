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
    case restart = "Restart"
    
    /// The name of the texture to use for a button when the button is selected.
    var selectedTextureName: String? {
        switch self {
        default:
            return nil
        }
    }
}
