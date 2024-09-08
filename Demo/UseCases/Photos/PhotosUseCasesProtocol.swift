import Foundation
import Combine

protocol PhotosUseCasesProtocol: DemoUseCases {
    func getPhotos(albumID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Photo], AppError>
    func add(photo: Photo) -> AnyPublisher<Photo, AppError>
    func delete(photos: [Photo]) -> AnyPublisher<Void, AppError>
}
