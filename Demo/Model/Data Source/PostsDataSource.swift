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
    
    func getAllPosts() -> AnyPublisher<[Post], DefaultAppError> {
        performRequest(withRelativeURL: "posts")
    }
    
}
