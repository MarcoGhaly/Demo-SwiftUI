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
        var urlString = "posts"
        userID.map { urlString += "?userId=\($0)" }
        return performRequest(withRelativeURL: urlString)
    }
    
}
