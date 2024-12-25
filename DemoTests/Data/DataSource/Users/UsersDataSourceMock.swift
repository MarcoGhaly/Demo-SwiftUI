import Foundation
import Combine
@testable import Demo

final class UsersDataSourceMock: DemoDataSourceMock, UsersDataSource {
    var stubbedRemoteUsers = [User]()
    var stubbedRemoteUsersCompletion: Subscribers.Completion<DataError> = .finished
    private(set) var getRemoteUsersCalls = [(page: Int?, limit: Int?)]()
    func getRemoteUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DataError> {
        getRemoteUsersCalls.append((page: page, limit: limit))
        let publisher = PassthroughSubject<[User], DataError>()
        publisher.send(self.stubbedRemoteUsers)
        publisher.send(completion: self.stubbedRemoteUsersCompletion)
        return publisher.eraseToAnyPublisher()
    }
    
    var stubbedLocalUsers = [User]()
    var stubbedLocalUsersCompletion: Subscribers.Completion<DataError> = .finished
    private(set) var getLocalUsersCallCount = 0
    func getLocalUsers() -> AnyPublisher<[User], DataError> {
        getLocalUsersCallCount += 1
        let publisher = PassthroughSubject<[User], DataError>()
        publisher.send(self.stubbedLocalUsers)
        publisher.send(completion: self.stubbedLocalUsersCompletion)
        return publisher.eraseToAnyPublisher()
    }
}
