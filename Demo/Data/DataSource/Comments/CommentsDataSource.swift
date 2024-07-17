import Foundation
import Combine

protocol CommentsDataSource: DemoDataSource {
    func getRemoteComments(postID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Comment], DefaultAPIError>
    func getLocalComments(postID: Int?) -> AnyPublisher<[Comment], DefaultAPIError>
}
