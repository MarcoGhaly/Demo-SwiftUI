//
//  CommentsStore.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class CommentsStore: ObservableObject {
    
    @Published var comments: [Comment] = []
    @Published var loading = false
    var subscriptions: [AnyCancellable] = []
    
    func fetchComments(postID: Int? = nil) {
        loading = true
        let commentsDataSource = CommentsDataSource()
        
        commentsDataSource.getComments(postID: postID)
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
            }) { [weak self] (comments) in
                self?.comments = comments
        }.store(in: &subscriptions)
    }
    
}
