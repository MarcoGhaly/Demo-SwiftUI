import Foundation
import Combine

protocol CommentsUseCasesProtocol: DemoUseCases {
    func getComments(postID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Comment], AppError>
    func add(comment: Comment) -> AnyPublisher<Comment, AppError>
    func delete(comments: [Comment]) -> AnyPublisher<Void, AppError>
}
