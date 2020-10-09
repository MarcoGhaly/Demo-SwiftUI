//
//  PostsStore.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PostsStore: ObservableObject {
    
    @Published var posts: [Post] = []
    @Published var loading = false
    var subscriptions: [AnyCancellable] = []
    
    func fetchPosts() {
        loading = true
        let postsDataSource = PostsDataSource()
        
        postsDataSource.getAllPosts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    break
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.loading = false
                }
            }) { [weak self] (posts) in
                self?.posts = posts
        }.store(in: &subscriptions)
    }
    
}
