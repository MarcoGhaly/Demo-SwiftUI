import Foundation
import Combine

class AlbumsUseCases: AlbumsUseCasesProtocol {
    var idKey: String { "NextAlbumID" }
    
    let dataSource: AlbumsDataSource

    var subscriptions: [AnyCancellable] = []
    
    init(dataSource: AlbumsDataSource = AlbumsRepository()) {
        self.dataSource = dataSource
    }
    
    func getAlbums(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Album], AppError> {
        var publisher = dataSource.getRemoteAlbums(userID: userID, page: page, limit: limit)
        
        if page == 1 {
            let localPublisher = dataSource.getLocalAlbums(userID: userID)
            publisher = Publishers.CombineLatest(publisher, localPublisher).map { remoteAlbums, localAlbums in
                localAlbums + remoteAlbums
            }.eraseToAnyPublisher()
        }
        
        return publisher
            .mapError { .general(error: $0) }
            .eraseToAnyPublisher()
    }
    
    func add(album: Album) -> AnyPublisher<Album, AppError> {
        let publisher = dataSource.addRemote(object: album)
        return publisher.map { [weak self] id in
            guard let self else { return album }
            let id = id.id ?? 1
            album.id = getNextID(withInitialValue: id)
            return dataSource.addLocal(object: album) ?? album
        }
        .mapError { .general(error: $0) }
        .eraseToAnyPublisher()
    }
    
    func delete(albums: [Album]) -> AnyPublisher<Void, AppError> {
        let publishers = albums.map { album in
            let publisher = dataSource.deleteRemote(object: album)
            
            publisher.sink { _ in
            } receiveValue: { _ in
                let _: Album? = self.dataSource.deleteLocal(object: album)
            }
            .store(in: &subscriptions)
            
            return publisher.map { _ in () }
            .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .reduce((), { (_, _) in () })
            .mapError { .general(error: $0) }
            .eraseToAnyPublisher()
    }
}
