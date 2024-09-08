import Foundation
import Combine

protocol UsersUseCasesProtocol: DemoUseCases {
    func getUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], AppError>
    func add(user: User) -> AnyPublisher<User, AppError>
    func delete(users: [User]) -> AnyPublisher<Void, AppError>
}
