//
//  Direction.swift
//  snake
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

enum Direction {
    case left, right, up, down, none
}

extension Direction {
    
    func isAbleToSwitch(toNew direction: Direction) -> Bool {
        var isSwitched = false
        
        switch self {
        case .left, .right:
            isSwitched = direction == .up || direction == .down
        case .up, .down:
            isSwitched = direction == .left || direction == .right
        case .none:
            return false
        }
        return isSwitched
    }
}

extension Direction {
    
    func toRotationDegrees() -> CGFloat {
        switch self {
        case .up:
            return 0
        case .down:
            return 180
        case .left:
            return 90
        case .right:
            return -90
        case .none:
            return -1
        }
    }
    
    func reversed() -> Direction {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        case .none:
            return self
        }
    }
    
    
}
