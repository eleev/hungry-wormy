//
//  StorageStatus.swift
//  device-kit
//
//  Created by Astemir Eleev on 16/11/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import UIKit

public struct StorageStatus {
    
    // MARK: - Properties
    
    // MARK: - Raw representations
    
    private var usedSpaceInBytes: Int64 {
        let usedSpace = totalSpaceInBytes - freeSpaceInBytes
        return usedSpace
    }
    
    private var freeSpaceInBytes: Int64 {
        if #available(iOS 11.0, *) {
            if let space = ((try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage) as Int64??) {
                return space ?? 0
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
                let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
        }
    }
    
    private var totalSpaceInBytes: Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }
    
    // MARK: - Methods
    
    public func getTotalSpace(_ unit: ByteCountFormatter.Units, includeUnitPostfix isUnitActive: Bool = true) -> String {
        return format(bytes: totalSpaceInBytes, to: unit, includeUnit: isUnitActive)
    }
    
    public func getFreeSpace(_ unit: ByteCountFormatter.Units, includeUnitPostfix isUnitActive: Bool = true) -> String {
        return format(bytes: freeSpaceInBytes, to: unit, includeUnit: isUnitActive)
    }
    
    public func getUsedSpace(_ unit: ByteCountFormatter.Units, includeUnitPostfix isUnitActive: Bool = true) -> String {
        return format(bytes: usedSpaceInBytes, to: unit, includeUnit: isUnitActive)
    }
    
}

// MARK: - Private helpers
extension StorageStatus {
    
    private func format(bytes: Int64, to unit: ByteCountFormatter.Units, includeUnit: Bool) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.allowedUnits = unit
        formatter.includesUnit = includeUnit
        return formatter.string(fromByteCount: bytes)
    }
}
