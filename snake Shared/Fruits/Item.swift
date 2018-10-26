//
//  Item.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

enum Item: String, CaseIterable {
    case blue = "platformPack_item001"
    case yellow  = "platformPack_item002"
    case green = "platformPack_item003"
    case red = "platformPack_item004"
}

extension Item {
    
    static func random() -> Item? {
        return Item.allCases.randomElement()
    }
    
    func get() -> SKTexture {
        return SKTexture(imageNamed: rawValue)
    }
}
