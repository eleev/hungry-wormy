//
//  SnakeParts.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

enum SnakeParts: String, CaseIterable {
    case bear
    case buffalo
    case chick
    case chicken
    case cow
    case crocodile
    case dog
    case duck
    case elephant
    case frog
    case giraffe
    case goat
    case gorilla
    case hippo
    case horse
    case monkey
    case moose
    case narwhal
    case owl
    case panda
    case parrot
    case penguin
    case pig
    case rabbit
    case rhino
    case sloth
    case snake
    case walrus
    case whale
    case zebra
}

extension SnakeParts {
    
    func getTexture() -> SKTexture {
        let name = self.rawValue
        return SKTexture(imageNamed: name)
    }
    
    static func random() -> SnakeParts? {
        return SnakeParts.allCases.randomElement()
    }
    
}
