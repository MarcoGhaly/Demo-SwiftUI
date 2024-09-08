import Foundation
import Combine

protocol PostsUseCasesProtocol: DemoUseCases {
    func getPosts(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Post], AppError>
    func add(post: Post) -> AnyPublisher<Post, AppError>
    func delete(posts: [Post]) -> AnyPublisher<Void, AppError>
}
