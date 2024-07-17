import Foundation
import Combine

class CommentsRepository: CommentsDataSource {
    let networkAgent: NetworkAgentProtocol
    var methodName: String { "comments" }
    
    init(networkAgent: NetworkAgentProtocol = NetworkAgent()) {
        self.networkAgent = networkAgent
    }
    
    func getRemoteComments(postID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Comment], DefaultAPIError> {
        let queryParameters = queryParameters(from: postID)
        return getRemoteData(queryParameters: queryParameters, page: page, limit: limit)
    }
    
    func getLocalComments(postID: Int?) -> AnyPublisher<[Comment], DefaultAPIError> {
        let queryParameters = queryParameters(from: postID)
        return getLocalData(queryParameters: queryParameters)
    }
}

private extension CommentsRepository {
    func queryParameters(from postID: Int?) -> [String: String] {
        var queryParameters = [String: String]()
        postID.map { queryParameters["postId"] = String($0) }
        return queryParameters
    }
}
