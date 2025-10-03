import Foundation
import RealmSwift
import Combine

protocol DatabaseManagerProtocol {
    func loadObjects<T: Object>(predicate: NSPredicate?) throws -> [T]
    func save<T: Object>(object: T) throws -> T
    func deleteObjects<T: Object>(predicate: NSPredicate) throws -> [T]
}

extension DatabaseManagerProtocol {
    func loadObjects<T: Object>(predicate: NSPredicate? = nil) throws -> [T] {
        try loadObjects(predicate: predicate)
    }
}
