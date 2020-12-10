//
//  PostsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

struct PostsDataSource: DemoDataSource {
    func getPosts(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Post], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        var request = Request(url: "posts", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
    
    func add(post: Post) -> AnyPublisher<ID, DefaultAppError> {
        let request = Request(httpMethod: .POST, url: "posts", body: post)
        return performRequest(request)
    }
}
