import Foundation
import Combine

protocol AlbumsUseCasesProtocol: DemoUseCases {
    func getAlbums(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Album], AppError>
    func add(album: Album) -> AnyPublisher<Album, AppError>
    func delete(albums: [Album]) -> AnyPublisher<Void, AppError>
}
