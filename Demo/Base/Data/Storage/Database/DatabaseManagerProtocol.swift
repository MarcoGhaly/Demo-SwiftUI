import Foundation
import RealmSwift
import Combine

protocol DatabaseManagerProtocol {
    func loadObjects<T>(predicate: NSPredicate?) -> AnyPublisher<[T], StorageError> where T: Object
    func save<T>(object: T) throws -> T where T: Object
    func deleteObjects<T>(predicate: NSPredicate) throws -> [T] where T: Object
}

extension DatabaseManagerProtocol {
    func loadObjects<T>(predicate: NSPredicate? = nil) -> AnyPublisher<[T], StorageError> where T: Object {
        loadObjects(predicate: predicate)
    }
}
