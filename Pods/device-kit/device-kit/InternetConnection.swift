//
//  InternetConnection.swift
//  device-kit
//
//  Created by Astemir Eleev on 01/12/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import SystemConfiguration

public enum InternetConnection {
    case open
    case closed
    
    public enum Status {
        case reachable
        case unreachable
    }
}

extension InternetConnection {
    
    public static func check() -> (connection: InternetConnection, status: InternetConnection.Status) {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return (connection: .closed, status: .unreachable)
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        let status = isReachable ? Status.reachable : Status.unreachable
        let connectivity = (isReachable && !needsConnection) ? InternetConnection.open : InternetConnection.closed
        
        return (connection: connectivity, status: status)
    }
}
