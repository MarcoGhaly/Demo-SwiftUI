//
//  CommentsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class CommentsViewModel: LCEViewModel<[Comment]> {
    
    private var postID: Int?
    
    init(postID: Int? = nil) {
        self.postID = postID
    }
    
    override func dataPublisher() -> AnyPublisher<[Comment], DefaultAppError> {
        CommentsDataSource().getComments(postID: postID)
    }
    
}
