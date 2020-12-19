//
//  PostsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PostsDataSource: DemoDataSource {
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
        let request = Request(httpMethod: .POST, url: "posts", body: post)
        let publisher: AnyPublisher<ID, DefaultAppError> = performRequest(request)
        return publisher.map { id in
            post.id = self.getNextPostID(withInitialValue: id.id) ?? 0
            return (try? DatabaseManager.save(object: post)) ?? post
        }.eraseToAnyPublisher()
    }
    
    private func getNextPostID(withInitialValue postID: Int?) -> Int? {
        guard let postID: Int = UserDefaultsManager.loadValue(forKey: nextPostIdKey) ?? postID else { return nil }
        UserDefaultsManager.save(value: postID + 1, forKey: nextPostIdKey)
        return postID
    }
    
    func remove(posts: [Post]) -> AnyPublisher<Void, DefaultAppError> {
        let publishers: [AnyPublisher<Void, DefaultAppError>] = posts.map { post in
            let request = Request(httpMethod: .DELETE, url: "posts", pathParameters: [String(post.id)])
            let publisher: AnyPublisher<EmptyResponse, DefaultAppError> = performRequest(request)
            
            publisher.sink { _ in
            } receiveValue: { response in
                let predicate = NSPredicate(format: "id = %@", argumentArray: posts.map { $0.id })
                let _: [Post]? = try? DatabaseManager.deleteObjects(predicate: predicate)
            }
            .store(in: &subscriptions)
            
            return publisher.map { _ in () }
            .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .reduce((), { (_, _) in () })
            .eraseToAnyPublisher()
    }
}
