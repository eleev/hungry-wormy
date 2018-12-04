//
//  ButtonNodeResponderType.swift
//  hungry-worm
//
//  Created by Astemir Eleev on 19/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SpriteKit

/// A type that can respond to `ButtonNode` button press events.
protocol ButtonNodeResponderType: class {
    /// Responds to a button press.
    func buttonTriggered(button: ButtonNode)
}
