//
//  Orientation.swift
//  device-kit
//
//  Created by Astemir Eleev on 01/12/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public enum Orientation {
    case portrait
    case landscape
    
    public static var isPortrait: Bool {
        var isPortraitOrientation = true
        
        if UIDevice.current.orientation.isValidInterfaceOrientation {
            isPortraitOrientation = UIDevice.current.orientation.isPortrait
        } else {
            isPortraitOrientation = UIScreen.main.bounds.width < UIScreen.main.bounds.height
        }
        return isPortraitOrientation
    }
}

extension Orientation {
    static func get() -> Orientation {
        return Orientation.isPortrait ? .portrait : .landscape
    }
}
