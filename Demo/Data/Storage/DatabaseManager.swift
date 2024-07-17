import Foundation
import RealmSwift
import Combine

struct DatabaseManager {
    static func save<T>(object: T) throws -> T where T: Object {
        let realm = try Realm()
        try realm.write {
            realm.add(object)
        }
        return object.freeze()
    }
    
    static func loadObjects<T>(predicate: NSPredicate? = nil) throws -> AnyPublisher<[T], DefaultAPIError> where T: Object {
        let publisher = PassthroughSubject<[T], DefaultAPIError>()
        
        let realm = try Realm()
        var objects = realm.objects(T.self)
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        DispatchQueue.main.async {
            publisher.send(Array(objects.freeze()))
            publisher.send(completion: .finished)
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    static func deleteObjects<T>(predicate: NSPredicate) throws -> [T] where T: Object {
        let realm = try Realm()
        let objects = realm.objects(T.self).filter(predicate)
        try realm.write {
            realm.delete(objects)
        }
        return Array(objects.freeze())
    }
}
