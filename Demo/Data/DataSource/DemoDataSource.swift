//
//  DemoDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 29/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine
import RealmSwift

protocol DemoDataSource {
    var methodName: String { get }
    var queryParameters: [String: String]? { get }
    var networkAgent: NetworkAgentProtocol { get }
    
    func performRequest<DataModel: Decodable, ErrorModel: Decodable>(
        _ request: inout Request, page: Int?, limit: Int?
    ) -> AnyPublisher<DataModel, APIError<ErrorModel>>

    func getRemoteData<T>(
        queryParameters: [String: String]?, page: Int?, limit: Int?
    ) -> AnyPublisher<[T], DefaultAPIError> where T: Object, T: Decodable
    func addRemote<T>(object: T) -> AnyPublisher<ID, DefaultAPIError> where T: Object, T: Encodable, T: Identified
    func deleteRemote<T>(object: T) -> AnyPublisher<EmptyResponse, DefaultAPIError> where T: Object, T: Identified
    
    func getLocalData<T>(
        queryParameters: [String: String]?, page: Int?, limit: Int?
    ) -> AnyPublisher<[T], DefaultAPIError> where T: Object, T: Decodable
    func addLocal<T>(object: T) -> T? where T: Object, T: Encodable, T: Identified
    func deleteLocal<T>(object: T) -> T? where T: Object, T: Identified
}

extension DemoDataSource {
    var queryParameters: [String: String]? { ["_limit": String(5)] }
    
    func performRequest<DataModel: Decodable, ErrorModel: Decodable>(
        _ request: inout Request, page: Int? = nil, limit: Int? = nil
    ) -> AnyPublisher<DataModel, APIError<ErrorModel>> {
        var queryParameters = request.queryParameters ?? [:]
        page.map { queryParameters["_page"] = String($0) }
        limit.map { queryParameters["_limit"] = String($0) }
        request.queryParameters = queryParameters
        return networkAgent.performRequest(request)
    }
    
    func getRemoteData<T>(page: Int?, limit: Int?) -> AnyPublisher<[T], DefaultAPIError> where T: Object, T: Decodable {
        getRemoteData(queryParameters: nil, page: page, limit: limit)
    }

    func getRemoteData<T>(queryParameters: [String: String]? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[T], DefaultAPIError> where T: Object, T: Decodable {
        var parameters = queryParameters ?? [:]
        self.queryParameters.map { parameters.merge($0) { (current, _) in current } }
        
        var request = Request(url: methodName)
            .set(queryParameters: parameters)
        
        return performRequest(&request, page: page, limit: limit)
    }
    
    func addRemote<T>(object: T) -> AnyPublisher<ID, DefaultAPIError> where T: Object, T: Encodable, T: Identified {
        let request = Request(url: methodName)
            .set(httpMethod: .POST)
            .set(body: object)
        return networkAgent.performRequest(request)
    }
    
    func deleteRemote<T>(object: T) -> AnyPublisher<EmptyResponse, DefaultAPIError> where T: Object, T: Identified {
        let request = Request(url: methodName)
            .set(httpMethod: .DELETE)
            .set(pathParameters: [String(object.id)])
        return networkAgent.performRequest(request)
    }
}

extension DemoDataSource {
    func getLocalData<T>(
        queryParameters: [String: String]? = nil, page: Int? = nil, limit: Int? = nil
    ) -> AnyPublisher<[T], DefaultAPIError> where T: Object, T: Decodable {
        var predicate: NSPredicate?
        if let format = queryParameters?.map({ "\($0)=\($1)" }).joined(separator: "&"), !format.isEmpty {
            predicate = NSPredicate(format: format)
        }
        return (try? DatabaseManager.loadObjects(predicate: predicate))
        ?? Just([]).setFailureType(to: DefaultAPIError.self).eraseToAnyPublisher()
    }
    
    func addLocal<T>(object: T) -> T? where T: Object, T: Encodable, T: Identified {
        try? DatabaseManager.save(object: object)
    }
    
    func deleteLocal<T>(object: T) -> T? where T: Object, T: Identified {
        let predicate = NSPredicate(format: "id = %@", argumentArray: [object.id])
        return try? DatabaseManager.deleteObjects(predicate: predicate).first
    }
}
