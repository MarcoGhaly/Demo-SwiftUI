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

protocol DemoDataSource: class, BaseDataSource {
    var baseURL: String { get }
    var methodName: String { get }
    var queryParameters: [String: String]? { get }
    var idKey: String { get }
    
    var subscriptions: [AnyCancellable] { get set }
    
    func performRequest<DataModel: Codable, ErrorModel: Codable>(_ request: inout Request, page: Int?, limit: Int?) -> AnyPublisher<DataModel, AppError<ErrorModel>>
    
    func getNextID(withInitialValue id: Int?) -> Int?
    func add<T>(object: T) -> AnyPublisher<T, DefaultAppError> where T: Object, T: Encodable, T: Identified
    func remove<T>(objects: [T]) -> AnyPublisher<Void, DefaultAppError> where T: Object, T: Identified
}

extension DemoDataSource {
    var baseURL: String { "https://jsonplaceholder.typicode.com/" }
    var queryParameters: [String: String]? { ["_limit": String(5)] }
}

extension DemoDataSource {
    func performRequest<DataModel: Codable, ErrorModel: Codable>(_ request: inout Request) -> AnyPublisher<DataModel, AppError<ErrorModel>> {
        performRequest(&request, page: nil, limit: nil)
    }
    
    func performRequest<DataModel: Codable, ErrorModel: Codable>(_ request: inout Request, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<DataModel, AppError<ErrorModel>> {
        var queryParameters = request.queryParameters ?? [:]
        page.map { queryParameters["_page"] = String($0) }
        limit.map { queryParameters["_limit"] = String($0) }
        
        request.queryParameters = queryParameters
        return performRequest(request)
    }
}

extension DemoDataSource {
    func getNextID(withInitialValue id: Int?) -> Int? {
        guard let userID: Int = UserDefaultsManager.loadValue(forKey: idKey) ?? id else { return nil }
        UserDefaultsManager.save(value: userID + 1, forKey: idKey)
        return userID
    }
    
    func add<T>(object: T) -> AnyPublisher<T, DefaultAppError> where T: Object, T: Encodable, T: Identified {
        let request = Request(httpMethod: .POST, url: methodName, body: object)
        let publisher: AnyPublisher<ID, DefaultAppError> = performRequest(request)
        return publisher.map { id in
            object.id = self.getNextID(withInitialValue: id.id) ?? 0
            return (try? DatabaseManager.save(object: object)) ?? object
        }.eraseToAnyPublisher()
    }
    
    func remove<T>(objects: [T]) -> AnyPublisher<Void, DefaultAppError> where T: Object, T: Identified {
        let publishers: [AnyPublisher<Void, DefaultAppError>] = objects.map { object in
            let request = Request(httpMethod: .DELETE, url: methodName, pathParameters: [String(object.id)])
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
