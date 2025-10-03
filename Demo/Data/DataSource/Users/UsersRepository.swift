import Foundation
import Combine

struct UsersRepository: UsersDataSource {
    let methodName = "users"
    
    var networkAgent: NetworkAgentProtocol = NetworkAgent()
    var databaseManager: DatabaseManagerProtocol = DatabaseManager()

    func getRemoteUsers(page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[User], DataError> {
        getRemoteData(page: page, limit: limit)
    }
    
    func getLocalUsers() -> AnyPublisher<[User], DataError> {
        Future { promise in
            do {
                let users: [User] = try getLocalData()
                promise(.success(users))
            } catch {
                promise(.failure(.localError(error: error)))
            }
        }.eraseToAnyPublisher()
    }
}
