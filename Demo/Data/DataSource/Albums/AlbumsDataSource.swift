import Foundation
import Combine

protocol AlbumsDataSource: DemoDataSource {
    func getRemoteAlbums(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Album], DefaultAPIError>
    func getLocalAlbums(userID: Int?) -> AnyPublisher<[Album], DefaultAPIError>
}
