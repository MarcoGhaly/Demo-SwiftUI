//
//  PostsUseCasesProtocol.swift
//  Demo
//
//  Created by Marco Ghaly on 15.07.24.
//  Copyright © 2024 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol PostsUseCasesProtocol: DemoUseCases {
    func getPosts(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Post], DefaultAPIError>
    func add(post: Post) -> AnyPublisher<Post, DefaultAPIError>
    func delete(posts: [Post]) -> AnyPublisher<Void, DefaultAPIError>
}
