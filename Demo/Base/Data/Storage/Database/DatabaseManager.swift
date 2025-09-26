import Foundation
import RealmSwift
import Combine

struct DatabaseManager: DatabaseManagerProtocol {
    func save<T: Object>(object: T) throws -> T {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        } catch(let error) {
            throw StorageError.databaseError(error: error)
        }
        return object.freeze()
    }
    
    func loadObjects<T: Object>(predicate: NSPredicate? = nil) -> AnyPublisher<[T], StorageError> {
        let publisher = PassthroughSubject<[T], StorageError>()
        
        do {
            let realm = try Realm()
            var objects = realm.objects(T.self)
            if let predicate = predicate {
                objects = objects.filter(predicate)
            }
            DispatchQueue.main.async {
                publisher.send(Array(objects.freeze()))
                publisher.send(completion: .finished)
            }
        } catch(let error) {
            DispatchQueue.main.async {
                publisher.send(completion: .failure(.databaseError(error: error)))
            }
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    func deleteObjects<T: Object>(predicate: NSPredicate) throws -> [T] {
        do {
            let realm = try Realm()
            let objects = realm.objects(T.self).filter(predicate)
            try realm.write {
                realm.delete(objects)
            }
            return Array(objects.freeze())
        } catch(let error) {
            throw StorageError.databaseError(error: error)
        }
    }
}
