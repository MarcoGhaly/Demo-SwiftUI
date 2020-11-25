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
    
    private var userID: Int?
    
    init(userID: Int? = nil) {
        self.userID = userID
    }
    
    override func dataPublisher() -> AnyPublisher<[Post], DefaultAppError> {
        PostsDataSource().getPosts(userID: userID)
    }
    
}
