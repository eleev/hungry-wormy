//
//  FoodType.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

protocol Food {
    func textures() -> [SKTexture]
}

enum FoodType: Food {
    case bee
    case ladybug
    case mouse
    case slime
    
    enum Fish: Food {
        case green
        case pink
        
        func textures() -> [SKTexture] {
            switch self {
            case .green:
                return [SKTexture(imageNamed: "fishPink"), SKTexture(imageNamed: "fishPink_move")]
            case .pink:
                return [SKTexture(imageNamed: "fishGreen"), SKTexture(imageNamed: "fishGreen_move")]
            }
        }
    }
    
    static let allCases: [Food] = [FoodType.bee, FoodType.ladybug, FoodType.mouse, FoodType.slime, Fish.green, Fish.pink]
}

extension FoodType {
    func textures() -> [SKTexture] {
        switch self {
        case .bee:
            return [SKTexture(imageNamed: "bee"), SKTexture(imageNamed: "bee_move")]
        case .ladybug:
            return [SKTexture(imageNamed: "ladybug"), SKTexture(imageNamed: "ladybug_move")]
        case .mouse:
            return [SKTexture(imageNamed: "mouse"), SKTexture(imageNamed: "mouse_move")]
        case .slime:
            return [SKTexture(imageNamed: "slime"), SKTexture(imageNamed: "slime_move")]
        }
    }
}
