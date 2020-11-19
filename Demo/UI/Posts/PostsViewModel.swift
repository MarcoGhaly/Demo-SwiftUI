//
//  PostsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

class PostsViewModel: LCEViewModel<[Post]> {
    
    init(userID: Int? = nil) {
        let postsDataSource = PostsDataSource()
        super.init(model: [], publisher: postsDataSource.getPosts(userID: userID))
    }
    
}
