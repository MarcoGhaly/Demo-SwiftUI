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
        Future { promise in
            do {
                let queryParameters = queryParameters(from: userID)
                let posts: [Post] = try getLocalData(queryParameters: queryParameters)
                promise(.success(posts))
            } catch {
                promise(.failure(.localError(error: error)))
            }
        }.eraseToAnyPublisher()
    }
}

private extension PostsRepository {
    func queryParameters(from userID: Int?) -> [String: String] {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        return queryParameters
    }
}
