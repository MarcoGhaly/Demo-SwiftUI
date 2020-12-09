//
//  PostsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PostsViewModel: LCEListViewModel<Post> {
    var userID: Int?
    
    private let dataSource = DemoDataSource()
    
    init(userID: Int? = nil) {
        self.userID = userID
        super.init(limit: 5)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Post], DefaultAppError> {
        dataSource.getPosts(userID: userID, page: page, limit: limit)
    }
    
    func add(post: Post) {
        loading = true
        dataSource.add(post: post).sink { [weak self] completion in
            self?.loading = false
        } receiveValue: { [weak self] id in
            if let postID = self?.getPostID(withInitialValue: id.id) {
                var post = post
                post.id = postID
                self?.model?.insert(post, at: 0)
            }
        }.store(in: &subscriptions)
    }
    
    private func getPostID(withInitialValue postID: Int?) -> Int? {
        guard let postID: Int = UserDefaultsManager.loadValue(forKey: "NextPostID") ?? postID else { return nil }
        UserDefaultsManager.save(value: postID + 1, forKey: "NextPostID")
        return postID
    }
}
