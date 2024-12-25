import Foundation
import Combine

struct AlbumsRepository: AlbumsDataSource {
    let methodName = "albums"
    
    var networkAgent: NetworkAgentProtocol = NetworkAgent()
    var databaseManager: DatabaseManagerProtocol = DatabaseManager()

    func getRemoteAlbums(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Album], DataError> {
        let queryParameters = queryParameters(from: userID)
        return getRemoteData(queryParameters: queryParameters, page: page, limit: limit)
    }
    
    func getLocalAlbums(userID: Int?) -> AnyPublisher<[Album], DataError> {
        let queryParameters = queryParameters(from: userID)
        return getLocalData(queryParameters: queryParameters)
    }
}

private extension AlbumsRepository {
    func queryParameters(from userID: Int?) -> [String: String] {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        return queryParameters
    }
}
