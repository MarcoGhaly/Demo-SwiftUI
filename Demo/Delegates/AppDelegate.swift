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
        
        if let fileURL = configuration.fileURL?.path, let encryptionKey = configuration.encryptionKey {
            print("Realm: File URL = \(fileURL)")
            print("Realm: Encryption Key = \(encryptionKey.hexEncodedString())")
        }
    }
    
    private func createEncryptionKey() -> Data {
        var key = Data(count: 64)
        key.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in
            if let address = pointer.baseAddress {
                let result = SecRandomCopyBytes(kSecRandomDefault, 64, address)
                assert(result == 0, "Failed to get random bytes")
            }
        }
        LocalStore.save(encryptionKey: key)
        return key
    }
}
