//
//  PostsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol PostsDataSource: DemoDataSource {
    func getPosts(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Post], DefaultAppError>
    func add(post: Post) -> AnyPublisher<Post, DefaultAppError>
    func remove(posts: [Post]) -> AnyPublisher<Void, DefaultAppError>
}

extension PostsDataSource {
    func getPosts() -> AnyPublisher<[Post], DefaultAppError> { getPosts(userID: nil, page: nil, limit: nil) }
    func getPosts(userID: Int?) -> AnyPublisher<[Post], DefaultAppError> { getPosts(userID: userID, page: nil, limit: nil) }
    func getPosts(page: Int?, limit: Int?) -> AnyPublisher<[Post], DefaultAppError> { getPosts(userID: nil, page: page, limit: limit) }
}
