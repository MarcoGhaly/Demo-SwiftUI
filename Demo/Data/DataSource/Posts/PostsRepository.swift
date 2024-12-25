import Foundation
import Combine

struct PostsRepository: PostsDataSource {
    let methodName = "posts"
    
    var networkAgent: NetworkAgentProtocol = NetworkAgent()
    var databaseManager: DatabaseManagerProtocol = DatabaseManager()

    func getRemotePosts(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Post], DataError> {
        let queryParameters = queryParameters(from: userID)
        return getRemoteData(queryParameters: queryParameters, page: page, limit: limit)
    }
    
    func getLocalPosts(userID: Int?) -> AnyPublisher<[Post], DataError> {
        let queryParameters = queryParameters(from: userID)
        return getLocalData(queryParameters: queryParameters)
    }
}

private extension PostsRepository {
    func queryParameters(from userID: Int?) -> [String: String] {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        return queryParameters
    }
}
