//
//  PhysicsContactDelegate.swift
//  snake
//
//  Created by Astemir Eleev on 26/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

protocol PhysicsContactDelegate {
    func didBeginPhysicsContact(_ contact: SKPhysicsContact, completion: @escaping (Bool) -> ())
    func didEndPhysicsContact(_ contact: SKPhysicsContact)
}
