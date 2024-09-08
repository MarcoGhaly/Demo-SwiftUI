import Foundation
import Combine

class AlbumsViewModel<UseCases>: BaseLCEListViewModel<Album, AppError, UseCases> where UseCases: AlbumsUseCasesProtocol {
    let userID: Int?
    
    init(useCases: UseCases = AlbumsUseCases(), userID: Int? = nil, albums: [Album]? = nil) {
        self.userID = userID
        super.init(useCases: useCases, models: albums, limit: 20)
        setActions()
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Album], AppError> {
        useCases.getAlbums(userID: userID, page: page, limit: limit)
    }
    
    func add(album: Album) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        useCases.add(album: album).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] album in
            self?.model?.insert(album, at: 0)
        }
        .store(in: &subscriptions)
    }
    
    func deleteAlbums(withIDs ids: Set<Int>) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        let albums = ids.compactMap { albumID in
            model?.first { $0.id == albumID }
        }
        
        useCases.delete(albums: albums).sink { [weak self] completion in
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
                self?.deleteAlbums(withIDs: IDs)
            }
        }.store(in: &subscriptions)
    }
}
