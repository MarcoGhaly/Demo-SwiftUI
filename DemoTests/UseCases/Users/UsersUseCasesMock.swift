import Foundation
import Combine
@testable import Demo

final class UsersUseCasesMock: UsersUseCasesProtocol {
    var idKey = ""

    var stubbedUsers: [User]?
    var stubbedUsersCompletion: Subscribers.Completion<AppError> = .finished
    func getUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], AppError> {
        let users = stubbedUsers ?? .init(repeating: User(), count: page! < 3 ? limit! : 0)
        let publisher = PassthroughSubject<[User], AppError>()
        DispatchQueue.main.async {
            publisher.send(users)
            publisher.send(completion: self.stubbedUsersCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }

    private(set) var addUserCallCount = 0
    var stubbedAddUserCompletion: Subscribers.Completion<AppError> = .finished
    func add(user: User) -> AnyPublisher<User, AppError> {
        addUserCallCount += 1
        let publisher = PassthroughSubject<User, AppError>()
        DispatchQueue.main.async {
            publisher.send(user)
            publisher.send(completion: self.stubbedAddUserCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    private(set) var deleteUsersCallCount = 0
    var stubbedDeleteUsersCompletion: Subscribers.Completion<AppError> = .finished
    func delete(users: [User]) -> AnyPublisher<Void, AppError> {
        deleteUsersCallCount = 0
        let publisher = PassthroughSubject<Void, AppError>()
        DispatchQueue.main.async {
            publisher.send()
            publisher.send(completion: self.stubbedDeleteUsersCompletion)
        }
        return publisher.eraseToAnyPublisher()
    }
}
