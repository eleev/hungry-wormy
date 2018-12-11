//
//  PauseTogglable.swift
//  hungry-worm iOS
//
//  Created by Astemir Eleev on 04/12/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

/// The protocol allows different external events (pause/resume button tapps) to be delegated to the target scene that will trigger platform/domain specific code in order to perform the requrested action
protocol PauseTogglable: class {
    func didTogglePause()
}
