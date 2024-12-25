import Foundation
import Combine

class PhotosUseCases: PhotosUseCasesProtocol {
    var idKey: String { "NextPhotoID" }
    
    let dataSource: PhotosDataSource

    var subscriptions: [AnyCancellable] = []
    
    init(dataSource: PhotosDataSource = PhotosRepository()) {
        self.dataSource = dataSource
    }
    
    func getPhotos(albumID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Photo], AppError> {
        var publisher = dataSource.getRemotePhotos(albumID: albumID, page: page, limit: limit)
        
        if page == 1 {
            let localPublisher = dataSource.getLocalPhotos(albumID: albumID)
            publisher = Publishers.CombineLatest(publisher, localPublisher).map { remotePhotos, localPhotos in
                localPhotos + remotePhotos
            }.eraseToAnyPublisher()
        }
        
        return publisher
            .mapError { .general(error: $0) }
            .eraseToAnyPublisher()
    }
    
    func add(photo: Photo) -> AnyPublisher<Photo, AppError> {
        let publisher = dataSource.addRemote(object: photo)
        return publisher.map { [weak self] id in
            guard let self else { return photo }
            let id = id.id ?? 1
            photo.id = getNextID(withInitialValue: id)
            return dataSource.addLocal(object: photo) ?? photo
        }
        .mapError { .general(error: $0) }
        .eraseToAnyPublisher()
    }
    
    func delete(photos: [Photo]) -> AnyPublisher<Void, AppError> {
        let publishers = photos.map { photo in
            let publisher = dataSource.deleteRemote(object: photo)
            
            publisher.sink { _ in
            } receiveValue: { _ in
                let _: Photo? = self.dataSource.deleteLocal(object: photo)
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
