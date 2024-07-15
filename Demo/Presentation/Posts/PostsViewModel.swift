//
//  PostsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PostsViewModel<UseCases: PostsUseCases>: BaseLCEListViewModel<Post, UseCases> {
    let userID: Int?
    
    init(useCases: UseCases = PostsUseCases(), userID: Int? = nil, posts: [Post]? = nil) {
        self.userID = userID
        super.init(useCases: useCases, models: posts, limit: 5)
        setActions()
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Post], DefaultAPIError> {
        useCases.getPosts(userID: userID, page: page, limit: limit)
    }
    
    func add(post: Post) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        useCases.add(post: post).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] post in
            self?.model?.insert(post, at: 0)
        }
        .store(in: &subscriptions)
    }
    
    private func deletePosts(withIDs ids: Set<Int>) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        let posts = ids.compactMap { postID in
            model?.first { $0.id == postID }
        }
        
        useCases.delete(posts: posts).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] _ in
            self?.model?.removeAll { ids.contains($0.id) }
        }
        .store(in: &subscriptions)
    }
    
    private func setActions() {
        actionPublisher.sink { [weak self] action in
            switch action {
            case .add:
                break
            case .delete(let IDs):
                self?.deletePosts(withIDs: IDs)
            }
        }.store(in: &subscriptions)
    }
}
