import Foundation
import Combine

class UsersUseCases: UsersUseCasesProtocol {
    var idKey: String { "NextUserID" }
    
    let dataSource: UsersDataSource
    
    var subscriptions = [AnyCancellable]()
    
    init(dataSource: UsersDataSource = UsersRepository()) {
        self.dataSource = dataSource
    }
    
    func getUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], AppError> {
        var publisher = dataSource.getRemoteUsers(page: page, limit: limit)
        
        if page == 1 {
            let localPublisher = dataSource.getLocalUsers()
            publisher = Publishers.CombineLatest(publisher, localPublisher).map { remoteUsers, localUsers in
                localUsers + remoteUsers
            }.eraseToAnyPublisher()
        }
        
        return publisher
            .mapError { .general(error: $0) }
            .eraseToAnyPublisher()
    }
    
    func add(user: User) -> AnyPublisher<User, AppError> {
        let publisher = dataSource.addRemote(object: user)
        return publisher.map { [weak self] id in
            guard let self else { return user }
            let id = id.id ?? 1
            user.id = getNextID(withInitialValue: id)
            return dataSource.addLocal(object: user) ?? user
        }
        .mapError { .general(error: $0) }
        .eraseToAnyPublisher()
    }
    
    func delete(users: [User]) -> AnyPublisher<Void, AppError> {
        let publishers = users.map { user in
            let publisher = dataSource.deleteRemote(object: user)
            
            publisher.sink { _ in
            } receiveValue: { _ in
                let _: User? = self.dataSource.deleteLocal(object: user)
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
