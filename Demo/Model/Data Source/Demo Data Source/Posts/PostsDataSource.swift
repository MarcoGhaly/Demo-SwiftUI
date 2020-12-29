//
//  PostsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PostsDataSource: BaseDemoDataSource {
    private let nextPostIdKey = "NextPostID"
    private var subscriptions: [AnyCancellable] = []
    
    func getPosts(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Post], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        var request = Request(url: "posts", queryParameters: queryParameters)
        var postsPublisher: AnyPublisher<[Post], DefaultAppError> = performRequest(&request, page: page, limit: limit)
        
        if page == 1, let userID = userID {
            let predicate = NSPredicate(format: "userId = %d", userID)
            if let localPostsPublisher: AnyPublisher<[Post], DefaultAppError> = try? DatabaseManager.loadObjects(predicate: predicate) {
                postsPublisher = Publishers.CombineLatest(postsPublisher, localPostsPublisher).map { remotePosts, localPosts in
                    localPosts + remotePosts
                }.eraseToAnyPublisher()
            }
        }
        
        return postsPublisher
    }
    
    func add(post: Post) -> AnyPublisher<Post, DefaultAppError> {
        add(object: post, method: "posts", idKey: nextPostIdKey)
    }
    
    func remove(posts: [Post]) -> AnyPublisher<Void, DefaultAppError> {
        remove(objects: posts, method: "posts")
    }
}
