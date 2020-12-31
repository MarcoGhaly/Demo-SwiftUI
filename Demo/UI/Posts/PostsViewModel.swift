//
//  PostsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PostsViewModel<DataSource: PostsDataSource>: BaseLCEListViewModel<Post, DataSource> {
    var userID: Int?
    
    init(dataSource: DataSource, userID: Int? = nil) {
        self.userID = userID
        super.init(dataSource: dataSource, limit: 5)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Post], DefaultAppError> {
        dataSource.getPosts(userID: userID, page: page, limit: limit)
    }
    
    func add(post: Post) {
        add(object: post)
    }
    
    func deletePosts(wihtIDs postsIDs: Set<Post.ID>) {
        deleteObjects(withIDs: postsIDs)
    }
}
