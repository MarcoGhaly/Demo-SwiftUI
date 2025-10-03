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
        Future { promise in
            do {
                let queryParameters = queryParameters(from: userID)
                let toDos: [ToDo] = try getLocalData(queryParameters: queryParameters)
                promise(.success(toDos))
            } catch {
                promise(.failure(.localError(error: error)))
            }
        }.eraseToAnyPublisher()
    }
}

private extension ToDosRepository {
    func queryParameters(from userID: Int?) -> [String: String] {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        return queryParameters
    }
}
