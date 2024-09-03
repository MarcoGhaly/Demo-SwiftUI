import Foundation
import Combine
@testable import Demo

class UsersUseCasesMock: UsersUseCasesProtocol {
    var idKey = ""

    var stubbedUsers: [User]?
    var stubbedUsersCompletion: Subscribers.Completion<DefaultAPIError> = .finished
    func getUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DefaultAPIError> {
        let users = stubbedUsers ?? .init(repeating: User(), count: page! < 3 ? limit! : 0)
        let publisher = PassthroughSubject<[User], DefaultAPIError>()
        DispatchQueue.main.async {
            publisher.send(users)
            publisher.send(completion: self.stubbedUsersCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }

    private(set) var addUserCallCount = 0
    var stubbedAddUserCompletion: Subscribers.Completion<DefaultAPIError> = .finished
    func add(user: User) -> AnyPublisher<User, DefaultAPIError> {
        addUserCallCount += 1
        let publisher = PassthroughSubject<User, DefaultAPIError>()
        DispatchQueue.main.async {
            publisher.send(user)
            publisher.send(completion: self.stubbedAddUserCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    private(set) var deleteUsersCallCount = 0
    var stubbedDeleteUsersCompletion: Subscribers.Completion<DefaultAPIError> = .finished
    func delete(users: [User]) -> AnyPublisher<Void, DefaultAPIError> {
        deleteUsersCallCount = 0
        let publisher = PassthroughSubject<Void, DefaultAPIError>()
        DispatchQueue.main.async {
            publisher.send()
            publisher.send(completion: self.stubbedDeleteUsersCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
}
