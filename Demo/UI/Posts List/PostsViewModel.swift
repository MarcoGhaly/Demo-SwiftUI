//
//  PostsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PostsViewModel: LCEViewModel<[Post]> {
    
    init() {
        let postsDataSource = PostsDataSource()
        super.init(model: [], publisher: postsDataSource.getAllPosts())
    }
    
}
