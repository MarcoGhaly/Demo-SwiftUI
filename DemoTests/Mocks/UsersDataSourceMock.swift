import Foundation
import Combine
@testable import Demo

final class UsersDataSourceMock: DemoDataSourceMock, UsersDataSource {
    var stubbedRemoteUsers = [User]()
    var stubbedRemoteUsersCompletion: Subscribers.Completion<DefaultAPIError> = .finished
    func getRemoteUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DefaultAPIError> {
        let publisher = PassthroughSubject<[User], DefaultAPIError>()
        DispatchQueue.main.async {
            publisher.send(self.stubbedRemoteUsers)
            publisher.send(completion: self.stubbedRemoteUsersCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    var stubbedLocalUsers = [User]()
    var stubbedLocalUsersCompletion: Subscribers.Completion<DefaultAPIError> = .finished
    func getLocalUsers() -> AnyPublisher<[User], DefaultAPIError> {
        let publisher = PassthroughSubject<[User], DefaultAPIError>()
        DispatchQueue.main.async {
            publisher.send(self.stubbedLocalUsers)
            publisher.send(completion: self.stubbedLocalUsersCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
}
