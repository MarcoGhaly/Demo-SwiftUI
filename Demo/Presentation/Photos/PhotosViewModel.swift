import Foundation
import Combine

class PhotosViewModel<UseCases>: BaseLCEListViewModel<Photo, AppError, UseCases> where UseCases: PhotosUseCasesProtocol {
    let albumID: Int?
    
    init(useCases: UseCases = PhotosUseCases(), albumID: Int? = nil, photos: [Photo]? = nil) {
        self.albumID = albumID
        super.init(useCases: useCases, models: photos, limit: 50)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Photo], AppError> {
        useCases.getPhotos(albumID: albumID, page: page, limit: limit)
    }
    
    func add(photo: Photo) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        useCases.add(photo: photo).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] photo in
            self?.model?.insert(photo, at: 0)
        }
        .store(in: &subscriptions)
    }
    
    func deletePhotos(withIDs ids: Set<Int>) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        let photos = ids.compactMap { photoID in
            model?.first { $0.id == photoID }
        }
        
        useCases.delete(photos: photos).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] _ in
            self?.model?.removeAll { ids.contains($0.id) }
        }
        .store(in: &subscriptions)
    }
    
    private func setActions() {
        actionPublisher.sink { [weak self] action in
            switch action {
            case .add:
                break
            case .delete(let IDs):
                self?.deletePhotos(withIDs: IDs)
            }
        }.store(in: &subscriptions)
    }
}
