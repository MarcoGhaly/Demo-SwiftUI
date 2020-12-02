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
    private var userID: Int?
    
    init(userID: Int? = nil) {
        self.userID = userID
        super.init(limit: 5)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Post], DefaultAppError> {
        DemoDataSource().getPosts(userID: userID, page: page, limit: limit)
    }
}
