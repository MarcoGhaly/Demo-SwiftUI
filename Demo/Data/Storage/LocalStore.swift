//
//  LocalStore.swift
//  Demo
//
//  Created by Marco Ghaly on 15/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

struct LocalStore {
    private static let ecnryptionKeyKey = "EncryptionKey"
    
    static func save(encryptionKey key: Data) {
        UserDefaultsManager.save(value: key, forKey: ecnryptionKeyKey)
    }
    
    static func loadEncryptionKey() -> Data? {
        UserDefaultsManager.loadValue(forKey: ecnryptionKeyKey)
    }
}
