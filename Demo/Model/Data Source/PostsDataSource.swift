//
//  PostsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

struct PostsDataSource: BaseDataSource {
    
    func getPosts(userID: Int? = nil) -> AnyPublisher<[Post], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        let request = Request(url: "posts", queryParameters: queryParameters)
        return performRequest(request)
    }
    
}
