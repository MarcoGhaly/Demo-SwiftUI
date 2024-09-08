import Foundation
import Combine

class CommentsViewModel<UseCases>: BaseLCEListViewModel<Comment, AppError, UseCases> where UseCases: CommentsUseCasesProtocol {
    let postID: Int?
    
    init(useCases: UseCases = CommentsUseCases(), postID: Int? = nil, comments: [Comment]? = nil) {
        self.postID = postID
        super.init(useCases: useCases, models: comments, limit: 10)
        setActions()
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Comment], AppError> {
        useCases.getComments(postID: postID, page: page, limit: limit)
    }
    
    func add(comment: Comment) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        useCases.add(comment: comment).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] comment in
            self?.model?.insert(comment, at: 0)
        }
        .store(in: &subscriptions)
    }
    
    func deleteComments(withIDs ids: Set<Int>) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        let comments = ids.compactMap { commentID in
            model?.first { $0.id == commentID }
        }
        
        useCases.delete(comments: comments).sink { [weak self] completion in
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
                self?.deleteComments(withIDs: IDs)
            }
        }.store(in: &subscriptions)
    }
}
