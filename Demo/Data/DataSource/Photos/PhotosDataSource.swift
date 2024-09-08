import Foundation
import Combine

protocol PhotosDataSource: DemoDataSource {
    func getRemotePhotos(albumID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Photo], DataError>
    func getLocalPhotos(albumID: Int?) -> AnyPublisher<[Photo], DataError>
}
