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
    private let nextPostIdKey = "NextPostID"
    
    func getPosts(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Post], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        var request = Request(url: "posts", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
    
    func add(post: Post) -> AnyPublisher<Post, DefaultAppError> {
        let request = Request(httpMethod: .POST, url: "posts", body: post)
        let publisher: AnyPublisher<ID, DefaultAppError> = performRequest(request)
        return publisher.map { id in
            var post = post
            post.id = getNextPostID(withInitialValue: id.id)
            return post
        }.eraseToAnyPublisher()
    }
    
    private func getNextPostID(withInitialValue postID: Int?) -> Int? {
        guard let postID: Int = UserDefaultsManager.loadValue(forKey: nextPostIdKey) ?? postID else { return nil }
        UserDefaultsManager.save(value: postID + 1, forKey: nextPostIdKey)
        return postID
    }
}
