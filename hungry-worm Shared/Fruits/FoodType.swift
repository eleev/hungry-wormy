//
//  FoodType.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

enum FoodType {
    case bee
    case ladybug
    
    enum Fish {
        case green
        case pink
    }
}

extension FoodType {
    func textures() -> [SKTexture] {
        switch self {
        case .bee:
            return [SKTexture(imageNamed: "bee"), SKTexture(imageNamed: "bee_move")]
        case .ladybug:
            return [SKTexture(imageNamed: "ladybug"), SKTexture(imageNamed: "ladybug_move")]
        }
    }
}
