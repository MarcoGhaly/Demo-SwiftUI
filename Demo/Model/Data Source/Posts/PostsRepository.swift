//
//  PostsRepository.swift
//  Demo
//
//  Created by Marco Ghaly on 29/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PostsRepository: PostsDataSource {
    var methodName: String { "posts" }
    
    var idKey: String { "NextPostID" }
    
    var subscriptions: [AnyCancellable] = []
    
    func getPosts(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Post], DefaultAPIError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        return getData(queryParameters: queryParameters, page: page, limit: limit)
    }
}
