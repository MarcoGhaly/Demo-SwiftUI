//
//  PostsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PostsDataSource: BaseDataSource {
    
    func getAllPosts() -> AnyPublisher<[Post], AppError> {
        return performRequest(withRelativeURL: "posts")
    }
    
}
