//
//  DemoDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 28/11/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

struct DemoDataSource: BaseDataSource {
    var baseURL: String { "https://jsonplaceholder.typicode.com/" }
    var queryParameters: [String: String]? { ["_limit": String(5)] }
}

extension DemoDataSource {
    func getAllUsers(page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[User], DefaultAppError> {
        var request = Request(url: "users", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
    
    func getPosts(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Post], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        var request = Request(url: "posts", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
    
    func getComments(postID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Comment], DefaultAppError> {
        var queryParameters = [String: String]()
        postID.map { queryParameters["postId"] = String($0) }
        
        var request = Request(url: "comments", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
    
    func getToDos(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[ToDo], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        var request = Request(url: "todos", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
    
    func getAlbums(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Album], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        var request = Request(url: "albums", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
    
    func getPhotos(albumID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Photo], DefaultAppError> {
        var queryParameters = [String: String]()
        albumID.map { queryParameters["albumId"] = String($0) }
        
        var request = Request(url: "photos", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
    
    private func performRequest<DataModel: Codable, ErrorModel: Codable>(_ request: inout Request, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<DataModel, AppError<ErrorModel>> {
        var queryParameters = request.queryParameters ?? [:]
        page.map { queryParameters["_page"] = String($0) }
        limit.map { queryParameters["_limit"] = String($0) }
        
        request.queryParameters = queryParameters
        return performRequest(request)
    }
}
