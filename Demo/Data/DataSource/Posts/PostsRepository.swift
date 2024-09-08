import Foundation
import Combine

class PostsRepository: PostsDataSource {
    let networkAgent: NetworkAgentProtocol
    var methodName: String { "posts" }
    
    init(networkAgent: NetworkAgentProtocol = NetworkAgent()) {
        self.networkAgent = networkAgent
    }
    
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
