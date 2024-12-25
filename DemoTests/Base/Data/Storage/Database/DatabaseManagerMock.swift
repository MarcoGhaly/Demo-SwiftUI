import Foundation
import Combine
import RealmSwift
@testable import Demo

final class DatabaseManagerMock: DatabaseManagerProtocol {
    var stubbedLoadedObjects = [Object]()
    var stubbedLoadObjectsCompletion: Subscribers.Completion<StorageError> = .finished
    private(set) var loadObjectsCalls = [NSPredicate?]()
    func loadObjects<T>(predicate: NSPredicate?) -> AnyPublisher<[T], StorageError> where T : Object {
        guard let stubbedLoadedObjects = stubbedLoadedObjects as? [T] else { fatalError() }
        
        loadObjectsCalls.append(predicate)
        
        let publisher = PassthroughSubject<[T], StorageError>()
        publisher.send(stubbedLoadedObjects)
        publisher.send(completion: stubbedLoadObjectsCompletion)
        return publisher.eraseToAnyPublisher()
    }
    
    private(set) var saveObjectCallCount = 0
    func save<T>(object: T) throws -> T where T : Object {
        saveObjectCallCount += 1
        return object
    }
    
    var stubbedDeletedObjects = [Object]()
    private(set) var deleteObjectsCalls = [NSPredicate?]()
    func deleteObjects<T>(predicate: NSPredicate) throws -> [T] where T : Object {
        guard let stubbedDeletedObjects = stubbedDeletedObjects as? [T] else { fatalError() }
        deleteObjectsCalls.append(predicate)
        return stubbedDeletedObjects
    }
}
