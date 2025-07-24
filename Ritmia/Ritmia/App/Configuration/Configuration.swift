//
//  Configuration.swift
//  Ritmia
//
//  Created on 24/10/24.
//

import Foundation

struct Configuration {
    // MARK: - Build Configuration
    
    #if DEBUG
    static let isDebug = true
    static let environment = "development"
    static let enableDebugMenu = true
    static let enableLogging = true
    #else
    static let isDebug = false
    static let environment = "production"
    static let enableDebugMenu = false
    static let enableLogging = false
    #endif
    
    // MARK: - App Configuration
    
    static let appName = "Ritmia"
    static let bundleIdentifier = "com.ritmia.Ritmia"
    static let minimumIOSVersion = "16.0"
    
    // MARK: - CloudKit Configuration
    
    static let cloudKitContainerIdentifier = "iCloud.com.ritmia.Ritmia"
    
    // MARK: - Feature Flags
    
    static let enableNotifications = false // For v1.5
    static let enableSocialSharing = true
    static let enableBiometricAuth = true
}
