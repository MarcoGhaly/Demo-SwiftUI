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
    
    func performRequest<DataModel: Decodable, ErrorModel: Decodable>(_ request: inout Request, page: Int?, limit: Int?) -> AnyPublisher<DataModel, AppError<ErrorModel>>
    
    func getNextID(withInitialValue id: Int?) -> Int?
    func getData<T>(queryParameters: [String: String]?, page: Int?, limit: Int?) -> AnyPublisher<[T], DefaultAppError> where T: Object, T: Decodable
    func add<T>(object: T) -> AnyPublisher<T, DefaultAppError> where T: Object, T: Encodable, T: Identified
    func remove<T>(objects: [T]) -> AnyPublisher<Void, DefaultAppError> where T: Object, T: Identified
}

extension DemoDataSource {
    var baseURL: String { "https://jsonplaceholder.typicode.com/" }
    var queryParameters: [String: String]? { ["_limit": String(5)] }
}

extension DemoDataSource {
    func performRequest<DataModel: Decodable, ErrorModel: Decodable>(_ request: inout Request, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<DataModel, AppError<ErrorModel>> {
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
    
    func getData<T>(queryParameters: [String: String]? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[T], DefaultAppError> where T: Object, T: Decodable {
        var parameters = queryParameters ?? [:]
        self.queryParameters.map { parameters.merge($0) { (current, _) in current } }
        
        var request = Request(url: methodName, queryParameters: parameters)
        var usersPublisher: AnyPublisher<[T], DefaultAppError> = performRequest(&request, page: page, limit: limit)
        
        if page == 1 {
            var predicate: NSPredicate?
            if let format = queryParameters?.map({ "\($0)=\($1)" }).joined(separator: "&"), !format.isEmpty {
                predicate = NSPredicate(format: format)
            }
            
            if let localUsersPublisher: AnyPublisher<[T], DefaultAppError> = try? DatabaseManager.loadObjects(predicate: predicate) {
                usersPublisher = Publishers.CombineLatest(usersPublisher, localUsersPublisher).map { remoteUsers, localUsers in
                    localUsers + remoteUsers
                }.eraseToAnyPublisher()
            }
        }
        
        return usersPublisher
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add<T>(object: T) -> AnyPublisher<T, DefaultAppError> where T: Object, T: Encodable, T: Identified {
        let request = Request(httpMethod: .POST, url: methodName, body: object)
        let publisher: AnyPublisher<ID, DefaultAppError> = performRequest(request)
        return publisher.map { id in
            object.id = self.getNextID(withInitialValue: id.id) ?? 0
            return (try? DatabaseManager.save(object: object)) ?? object
        }
        .eraseToAnyPublisher()
        // Add a delay to see the loading view
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func remove<T>(objects: [T]) -> AnyPublisher<Void, DefaultAppError> where T: Object, T: Identified {
        let publishers: [AnyPublisher<Void, DefaultAppError>] = objects.map { object in
            let request = Request(httpMethod: .DELETE, url: methodName, pathParameters: [String(object.id)])
            let publisher: AnyPublisher<EmptyResponse, DefaultAppError> = performRequest(request)
            
            publisher.sink { _ in
            } receiveValue: { _ in
                let predicate = NSPredicate(format: "id = %@", argumentArray: [object.id])
                let _: [T]? = try? DatabaseManager.deleteObjects(predicate: predicate)
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
