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
    
    private let dataSource = PostsDataSource()
    
    init(userID: Int? = nil) {
        self.userID = userID
        super.init(limit: 5)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Post], DefaultAppError> {
        dataSource.getPosts(userID: userID, page: page, limit: limit)
    }
    
    func add(post: Post) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        dataSource.add(post: post).sink { [weak self] completion in
            self?.viewState = .content
        } receiveValue: { [weak self] post in
            self?.model?.insert(post, at: 0)
        }
        .store(in: &subscriptions)
    }
    
    func deletePosts(wihtIDs postsIDs: Set<Post.ID>) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        let posts = postsIDs.compactMap { postID in
            model?.first(where: { $0.id == postID })
        }
        
        dataSource.remove(posts: posts).sink { [weak self] completion in
            self?.viewState = .content
        } receiveValue: { [weak self] _ in
            self?.model?.removeAll(where: { postsIDs.contains($0.id) })
        }
        .store(in: &subscriptions)
    }
}
