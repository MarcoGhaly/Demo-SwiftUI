//
//  BaseDemoDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 29/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine
import RealmSwift

class BaseDemoDataSource: DemoDataSource {
    private var subscriptions: [AnyCancellable] = []
    
    func getNextID(withInitialValue id: Int?, key: String) -> Int? {
        guard let userID: Int = UserDefaultsManager.loadValue(forKey: key) ?? id else { return nil }
        UserDefaultsManager.save(value: userID + 1, forKey: key)
        return userID
    }
    
    func add<T>(object: T, method: String, idKey: String) -> AnyPublisher<T, DefaultAppError> where T: Object, T: Encodable, T: Identified {
        let request = Request(httpMethod: .POST, url: method, body: object)
        let publisher: AnyPublisher<ID, DefaultAppError> = performRequest(request)
        return publisher.map { id in
            object.id = self.getNextID(withInitialValue: id.id, key: idKey) ?? 0
            return (try? DatabaseManager.save(object: object)) ?? object
        }.eraseToAnyPublisher()
    }
    
    func remove<T>(objects: [T], method: String) -> AnyPublisher<Void, DefaultAppError> where T: Object, T: Identified {
        let publishers: [AnyPublisher<Void, DefaultAppError>] = objects.map { object in
            let request = Request(httpMethod: .DELETE, url: method, pathParameters: [String(object.id)])
            let publisher: AnyPublisher<EmptyResponse, DefaultAppError> = performRequest(request)
            
            publisher.sink { _ in
            } receiveValue: { response in
                let predicate = NSPredicate(format: "id = %@", argumentArray: objects.map { $0.id })
                let _: [T]? = try? DatabaseManager.deleteObjects(predicate: predicate)
            }
            .store(in: &subscriptions)
            
            return publisher.map { _ in () }
            .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .reduce((), { (_, _) in () })
            .eraseToAnyPublisher()
    }
}
