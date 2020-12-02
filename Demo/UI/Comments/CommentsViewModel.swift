//
//  CommentsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class CommentsViewModel: LCEListViewModel<Comment> {
    private var postID: Int?
    
    init(postID: Int? = nil) {
        self.postID = postID
        super.init(limit: 10)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Comment], DefaultAppError> {
        DemoDataSource().getComments(postID: postID, page: page, limit: limit)
    }
}
