import Foundation
import Combine

class ToDosUseCases: ToDosUseCasesProtocol {
    var idKey: String { "NextToDoID" }
    
    let dataSource: ToDosDataSource

    var subscriptions: [AnyCancellable] = []
    
    init(dataSource: ToDosDataSource = ToDosRepository()) {
        self.dataSource = dataSource
    }
    
    func getToDos(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[ToDo], AppError> {
        var publisher = dataSource.getRemoteToDos(userID: userID, page: page, limit: limit)
        
        if page == 1 {
            let localPublisher = dataSource.getLocalToDos(userID: userID)
            publisher = Publishers.CombineLatest(publisher, localPublisher).map { remoteToDos, localToDos in
                localToDos + remoteToDos
            }.eraseToAnyPublisher()
        }
        
        return publisher
            .mapError { .general(error: $0) }
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(toDo: ToDo) -> AnyPublisher<ToDo, AppError> {
        let publisher = dataSource.addRemote(object: toDo)
        return publisher.map { [weak self] id in
            guard let self else { return toDo }
            let id = id.id ?? 1
            toDo.id = getNextID(withInitialValue: id)
            return dataSource.addLocal(object: toDo) ?? toDo
        }
        .mapError { .general(error: $0) }
        // Add a delay to see the loading view
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func delete(toDos: [ToDo]) -> AnyPublisher<Void, AppError> {
        let publishers = toDos.map { toDo in
            let publisher = dataSource.deleteRemote(object: toDo)
            
            publisher.sink { _ in
            } receiveValue: { _ in
                let _: ToDo? = self.dataSource.deleteLocal(object: toDo)
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
