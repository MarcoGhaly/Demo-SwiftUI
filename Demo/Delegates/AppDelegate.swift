//
//  AppDelegate.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let databaseVersion: UInt64 = 0
    private let realmCompactConfigurations: (fileSizeMB: Int, usageRatio: Double) = (100 * 1024 * 1024, 0.5)
    
    private var encryptionKey: Data {
        LocalStore.loadEncryptionKey() ?? createEncryptionKey()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initRealm()
        return true
    }
    
    private func initRealm() {
        let configuration = Realm.Configuration(encryptionKey: encryptionKey, schemaVersion: databaseVersion) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
            }
        } shouldCompactOnLaunch: { totalBytes, usedBytes in
            let fileSizeMB = self.realmCompactConfigurations.fileSizeMB
            let usageRatio = self.realmCompactConfigurations.usageRatio
            return (totalBytes > fileSizeMB) && (Double(usedBytes) / Double(totalBytes)) < usageRatio
        }
        Realm.Configuration.defaultConfiguration = configuration
    }
    
    private func createEncryptionKey() -> Data {
        var key = Data(count: 64)
        _ = key.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
        }
        LocalStore.save(encryptionKey: key)
        return key
    }
}
