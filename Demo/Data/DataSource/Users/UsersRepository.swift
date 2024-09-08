import Foundation
import Combine

class UsersRepository: UsersDataSource {
    let networkAgent: NetworkAgentProtocol
    var methodName: String { "users" }
    
    init(networkAgent: NetworkAgentProtocol = NetworkAgent()) {
        self.networkAgent = networkAgent
    }

    func getRemoteUsers(page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[User], DataError> {
        getRemoteData(page: page, limit: limit)
    }
    
    func getLocalUsers() -> AnyPublisher<[User], DataError> {
        getLocalData()
    }
}
