import Foundation
import Combine

protocol PhotosUseCasesProtocol: DemoUseCases {
    func getPhotos(albumID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Photo], DefaultAPIError>
    func add(photo: Photo) -> AnyPublisher<Photo, DefaultAPIError>
    func delete(photos: [Photo]) -> AnyPublisher<Void, DefaultAPIError>
}
