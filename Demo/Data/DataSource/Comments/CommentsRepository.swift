import Foundation
import Combine

struct CommentsRepository: CommentsDataSource {
    let methodName = "comments"
    
    var networkAgent: NetworkAgentProtocol = NetworkAgent()
    var databaseManager: DatabaseManagerProtocol = DatabaseManager()

    func getRemoteComments(postID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Comment], DataError> {
        let queryParameters = queryParameters(from: postID)
        return getRemoteData(queryParameters: queryParameters, page: page, limit: limit)
    }
    
    func getLocalComments(postID: Int?) -> AnyPublisher<[Comment], DataError> {
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
