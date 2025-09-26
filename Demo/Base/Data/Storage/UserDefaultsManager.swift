import Foundation

struct UserDefaultsManager {
    static func save<T: Encodable>(value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.setValue(data, forKey: key)
        }
    }
    
    static func loadValue<T: Decodable>(forKey key: String) -> T? {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    static func deleteValue(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
