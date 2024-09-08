import Foundation
import Combine

class CommentsUseCases: CommentsUseCasesProtocol {
    var idKey: String { "NextCommentID" }
    
    let dataSource: CommentsDataSource

    var subscriptions: [AnyCancellable] = []
    
    init(dataSource: CommentsDataSource = CommentsRepository()) {
        self.dataSource = dataSource
    }
    
    func getComments(postID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Comment], AppError> {
        var publisher = dataSource.getRemoteComments(postID: postID, page: page, limit: limit)
        
        if page == 1 {
            let localPublisher = dataSource.getLocalComments(postID: postID)
            publisher = Publishers.CombineLatest(publisher, localPublisher).map { remoteComments, localComments in
                localComments + remoteComments
            }.eraseToAnyPublisher()
        }
        
        return publisher
            .mapError { .general(error: $0) }
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(comment: Comment) -> AnyPublisher<Comment, AppError> {
        let publisher = dataSource.addRemote(object: comment)
        return publisher.map { [weak self] id in
            guard let self else { return comment }
            let id = id.id ?? 1
            comment.id = getNextID(withInitialValue: id)
            return dataSource.addLocal(object: comment) ?? comment
        }
        .mapError { .general(error: $0) }
        // Add a delay to see the loading view
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func delete(comments: [Comment]) -> AnyPublisher<Void, AppError> {
        let publishers = comments.map { comment in
            let publisher = dataSource.deleteRemote(object: comment)
            
            publisher.sink { _ in
            } receiveValue: { _ in
                let _: Comment? = self.dataSource.deleteLocal(object: comment)
            }
            .store(in: &subscriptions)
            
            return publisher.map { _ in () }
            .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .reduce((), { (_, _) in () })
            .mapError { .general(error: $0) }
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
