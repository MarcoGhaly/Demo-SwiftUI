import Foundation
import Combine

class AlbumsUseCases: AlbumsUseCasesProtocol {
    var idKey: String { "NextAlbumID" }
    
    let dataSource: AlbumsDataSource

    var subscriptions: [AnyCancellable] = []
    
    init(dataSource: AlbumsDataSource = AlbumsRepository()) {
        self.dataSource = dataSource
    }
    
    func getAlbums(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Album], DefaultAPIError> {
        var publisher: AnyPublisher<[Album], DefaultAPIError> = dataSource.getRemoteAlbums(userID: userID, page: page, limit: limit)
        
        if page == 1 {
            let localPublisher: AnyPublisher<[Album], DefaultAPIError> = dataSource.getLocalAlbums(userID: userID)
            publisher = Publishers.CombineLatest(publisher, localPublisher).map { remoteAlbums, localAlbums in
                localAlbums + remoteAlbums
            }.eraseToAnyPublisher()
        }
        
        return publisher
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(album: Album) -> AnyPublisher<Album, DefaultAPIError> {
        let publisher: AnyPublisher<ID, DefaultAPIError> = dataSource.addRemote(object: album)
        return publisher.map { [weak self] id in
            guard let self else { return album }
            let id = id.id ?? 1
            album.id = getNextID(withInitialValue: id)
            return dataSource.addLocal(object: album) ?? album
        }
        .eraseToAnyPublisher()
        // Add a delay to see the loading view
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func delete(albums: [Album]) -> AnyPublisher<Void, DefaultAPIError> {
        let publishers: [AnyPublisher<Void, DefaultAPIError>] = albums.map { album in
            let publisher: AnyPublisher<EmptyResponse, DefaultAPIError> = dataSource.deleteRemote(object: album)
            
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
            .eraseToAnyPublisher()
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
