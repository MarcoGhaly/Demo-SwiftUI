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
