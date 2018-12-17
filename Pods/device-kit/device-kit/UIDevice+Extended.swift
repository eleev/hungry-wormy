//
//  UIDevice+Extended.swift
//  device-kit
//
//  Created by Astemir Eleev on 16/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public extension UIDevice {
    
    /// Allows to get access to the current device type and model
    public var deviceType: DeviceType {
        return DeviceType.current
    }
    
    /// Allows to get access to the storage status such as:
    ///
    /// - totalSpace
    /// - freeSpace
    /// - usedSpace
    public var storageStatus: StorageStatus {
        return StorageStatus()
    }
    
    /// Allows to get the current device orientation (.landscape or .portrait)
    public var deviceOrientation: Orientation {
        return Orientation.get()
    }
    
    
    /// Checks the Internet connection & status. May return following results:
    ///
    /// - .open - when the internet connection is available
    /// - .closed - when the internet connection is not available
    ///
    /// Also there is Status enum type that returns reachability status such as:
    ///
    /// - .reachable - when the internet connection is reachable
    /// - .unreachable - when the internet connection is not reachable
    public var internetConnection: (connection: InternetConnection, status: InternetConnection.Status) {
        return InternetConnection.check()
    }
    
}
