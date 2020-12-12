//
//  PostsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine
import RealmSwift

struct PostsDataSource: DemoDataSource {
    private let nextPostIdKey = "NextPostID"
    
    func getPosts(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Post], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        var request = Request(url: "posts", queryParameters: queryParameters)
        var postsPublisher: AnyPublisher<[Post], DefaultAppError> = performRequest(&request, page: page, limit: limit)
        
        if page == 1, let userID = userID, let localPostsPublisher = try? loadPosts(userID: userID) {
            postsPublisher = Publishers.CombineLatest(postsPublisher, localPostsPublisher).map { remotePosts, localPosts in
                localPosts + remotePosts
            }.eraseToAnyPublisher()
        }
        
        return postsPublisher
    }
    
    func add(post: Post) -> AnyPublisher<Post, DefaultAppError> {
        let request = Request(httpMethod: .POST, url: "posts", body: post)
        let publisher: AnyPublisher<ID, DefaultAppError> = performRequest(request)
        return publisher.map { id in
            let post = post
            post.id = getNextPostID(withInitialValue: id.id) ?? 0
            try? save(post: post)
            return post
        }.eraseToAnyPublisher()
    }
    
    private func getNextPostID(withInitialValue postID: Int?) -> Int? {
        guard let postID: Int = UserDefaultsManager.loadValue(forKey: nextPostIdKey) ?? postID else { return nil }
        UserDefaultsManager.save(value: postID + 1, forKey: nextPostIdKey)
        return postID
    }
    
    private func save(post: Post) throws {
        let realm = try Realm()
        try realm.write {
            realm.add(post)
        }
    }
    
    private func loadPosts(userID: Int) throws -> AnyPublisher<[Post], DefaultAppError> {
        let publisher = PassthroughSubject<[Post], DefaultAppError>()
        
        let realm = try Realm()
        let posts = Array(realm.objects(Post.self).filter("userId = %d", userID))
        DispatchQueue.main.async {
            publisher.send(posts)
            publisher.send(completion: .finished)
        }
        
        return publisher.eraseToAnyPublisher()
    }
}
