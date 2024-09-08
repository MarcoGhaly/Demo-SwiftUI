import Foundation
import Combine
@testable import Demo

final class UsersDataSourceMock: DemoDataSourceMock, UsersDataSource {
    var stubbedRemoteUsers = [User]()
    var stubbedRemoteUsersCompletion: Subscribers.Completion<DataError> = .finished
    func getRemoteUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DataError> {
        let publisher = PassthroughSubject<[User], DataError>()
        DispatchQueue.main.async {
            publisher.send(self.stubbedRemoteUsers)
            publisher.send(completion: self.stubbedRemoteUsersCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    var stubbedLocalUsers = [User]()
    var stubbedLocalUsersCompletion: Subscribers.Completion<DataError> = .finished
    func getLocalUsers() -> AnyPublisher<[User], DataError> {
        let publisher = PassthroughSubject<[User], DataError>()
        DispatchQueue.main.async {
            publisher.send(self.stubbedLocalUsers)
            publisher.send(completion: self.stubbedLocalUsersCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
}
