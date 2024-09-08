import Foundation
import Combine

protocol AlbumsDataSource: DemoDataSource {
    func getRemoteAlbums(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Album], DataError>
    func getLocalAlbums(userID: Int?) -> AnyPublisher<[Album], DataError>
}
