//
//  ToDosUseCases.swift
//  Demo
//
//  Created by Marco Ghaly on 15.07.24.
//  Copyright © 2024 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class ToDosUseCases: ToDosUseCasesProtocol {
    var idKey: String { "NextToDoID" }
    
    let dataSource: ToDosDataSource

    var subscriptions: [AnyCancellable] = []
    
    init(dataSource: ToDosDataSource = ToDosRepository()) {
        self.dataSource = dataSource
    }
    
    func getToDos(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[ToDo], DefaultAPIError> {
        var publisher: AnyPublisher<[ToDo], DefaultAPIError> = dataSource.getRemoteToDos(userID: userID, page: page, limit: limit)
        
        if page == 1 {
            let localPublisher: AnyPublisher<[ToDo], DefaultAPIError> = dataSource.getLocalToDos(userID: userID)
            publisher = Publishers.CombineLatest(publisher, localPublisher).map { remoteToDos, localToDos in
                localToDos + remoteToDos
            }.eraseToAnyPublisher()
        }
        
        return publisher
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(toDo: ToDo) -> AnyPublisher<ToDo, DefaultAPIError> {
        let publisher: AnyPublisher<ID, DefaultAPIError> = dataSource.addRemote(object: toDo)
        return publisher.map { [weak self] id in
            guard let self else { return toDo }
            let id = id.id ?? 1
            toDo.id = getNextID(withInitialValue: id)
            return dataSource.addLocal(object: toDo) ?? toDo
        }
        .eraseToAnyPublisher()
        // Add a delay to see the loading view
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func delete(toDos: [ToDo]) -> AnyPublisher<Void, DefaultAPIError> {
        let publishers: [AnyPublisher<Void, DefaultAPIError>] = toDos.map { toDo in
            let publisher: AnyPublisher<EmptyResponse, DefaultAPIError> = dataSource.deleteRemote(object: toDo)
            
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
            .eraseToAnyPublisher()
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
