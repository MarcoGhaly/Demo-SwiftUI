import Foundation
import Combine

class PostsUseCases: PostsUseCasesProtocol {
    var idKey: String { "NextPostID" }
    
    let dataSource: PostsDataSource

    var subscriptions: [AnyCancellable] = []
    
    init(dataSource: PostsDataSource = PostsRepository()) {
        self.dataSource = dataSource
    }
    
    func getPosts(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Post], AppError> {
        var publisher = dataSource.getRemotePosts(userID: userID, page: page, limit: limit)
        
        if page == 1 {
            let localPublisher = dataSource.getLocalPosts(userID: userID)
            publisher = Publishers.CombineLatest(publisher, localPublisher).map { remotePosts, localPosts in
                localPosts + remotePosts
            }.eraseToAnyPublisher()
        }
        
        return publisher
            .mapError { .general(error: $0) }
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(post: Post) -> AnyPublisher<Post, AppError> {
        let publisher = dataSource.addRemote(object: post)
        return publisher.map { [weak self] id in
            guard let self else { return post }
            let id = id.id ?? 1
            post.id = getNextID(withInitialValue: id)
            return dataSource.addLocal(object: post) ?? post
        }
        .mapError { .general(error: $0) }
        // Add a delay to see the loading view
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func delete(posts: [Post]) -> AnyPublisher<Void, AppError> {
        let publishers = posts.map { post in
            let publisher = dataSource.deleteRemote(object: post)
            
            publisher.sink { _ in
            } receiveValue: { _ in
                let _: Post? = self.dataSource.deleteLocal(object: post)
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
