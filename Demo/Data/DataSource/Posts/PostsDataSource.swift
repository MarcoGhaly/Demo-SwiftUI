import Foundation
import Combine

protocol PostsDataSource: DemoDataSource {
    func getRemotePosts(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Post], DefaultAPIError>
    func getLocalPosts(userID: Int?) -> AnyPublisher<[Post], DefaultAPIError>
}
