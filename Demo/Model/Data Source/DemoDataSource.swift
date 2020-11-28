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
    func getAllUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DefaultAppError> {
        var queryParameters = [String: String]()
        page.map { queryParameters["_page"] = String($0) }
        limit.map { queryParameters["_limit"] = String($0) }
        
        let request = Request(url: "users", queryParameters: queryParameters)
        return performRequest(request)
    }
    
    func getPosts(userID: Int? = nil) -> AnyPublisher<[Post], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        let request = Request(url: "posts", queryParameters: queryParameters)
        return performRequest(request)
    }
    
    func getComments(postID: Int? = nil) -> AnyPublisher<[Comment], DefaultAppError> {
        var queryParameters = [String: String]()
        postID.map { queryParameters["postId"] = String($0) }
        
        let request = Request(url: "comments", queryParameters: queryParameters)
        return performRequest(request)
    }
    
    func getToDos(userID: Int? = nil) -> AnyPublisher<[ToDo], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        let request = Request(url: "todos", queryParameters: queryParameters)
        return performRequest(request)
    }
    
    func getAlbums(userID: Int? = nil) -> AnyPublisher<[Album], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        let request = Request(url: "albums", queryParameters: queryParameters)
        return performRequest(request)
    }
    
    func getPhotos(albumID: Int? = nil) -> AnyPublisher<[Photo], DefaultAppError> {
        var queryParameters = [String: String]()
        albumID.map { queryParameters["albumId"] = String($0) }
        
        let request = Request(url: "photos", queryParameters: queryParameters)
        return performRequest(request)
    }
}
