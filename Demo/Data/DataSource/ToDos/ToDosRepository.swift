import Foundation
import Combine

struct ToDosRepository: ToDosDataSource {
    let methodName = "todos"
    
    var networkAgent: NetworkAgentProtocol = NetworkAgent()
    var databaseManager: DatabaseManagerProtocol = DatabaseManager()

    func getRemoteToDos(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[ToDo], DataError> {
        let queryParameters = queryParameters(from: userID)
        return getRemoteData(queryParameters: queryParameters, page: page, limit: limit)
    }
    
    func getLocalToDos(userID: Int?) -> AnyPublisher<[ToDo], DataError> {
        let queryParameters = queryParameters(from: userID)
        return getLocalData(queryParameters: queryParameters)
    }
}

private extension ToDosRepository {
    func queryParameters(from userID: Int?) -> [String: String] {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        return queryParameters
    }
}
