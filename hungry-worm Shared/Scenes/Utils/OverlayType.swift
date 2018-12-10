//
//  OverlayType.swift
//  hungry-worm
//
//  Created by Astemir Eleev on 10/12/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

enum OverlayType {
    case pause
    case death
    case results
}

extension OverlayType {
    var sceneName: String {
        switch self {
        case .pause:
            return Scenes.pause.getName()
        case .death:
            return Scenes.death.getName()
        case .results:
            return Scenes.results.getName()
        }
    }
}
