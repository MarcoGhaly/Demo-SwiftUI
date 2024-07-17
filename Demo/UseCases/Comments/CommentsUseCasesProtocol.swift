import Foundation
import Combine

protocol CommentsUseCasesProtocol: DemoUseCases {
    func getComments(postID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Comment], DefaultAPIError>
    func add(comment: Comment) -> AnyPublisher<Comment, DefaultAPIError>
    func delete(comments: [Comment]) -> AnyPublisher<Void, DefaultAPIError>
}
