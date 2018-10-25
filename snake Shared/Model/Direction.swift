//
//  Direction.swift
//  snake
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

enum Direction {
    case left, right, up, down
}

extension Direction {
    
    func isAbleToSwitch(toNew direction: Direction) -> Bool {
        var isSwitched = false
        
        switch self {
        case .left, .right:
            isSwitched = direction == .up || direction == .down
        case .up, .down:
            isSwitched = direction == .left || direction == .right
        }
        return isSwitched
    }
}
