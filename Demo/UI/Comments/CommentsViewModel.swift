//
//  CommentsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class CommentsViewModel<DataSource: CommentsDataSource>: BaseLCEListViewModel<Comment, DataSource> {
    private let postID: Int?
    
    init(dataSource: DataSource, postID: Int? = nil, comments: [Comment]? = nil) {
        self.postID = postID
        super.init(dataSource: dataSource, models: comments, limit: 10)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Comment], DefaultAppError> {
        dataSource.getComments(postID: postID, page: page, limit: limit)
    }
}
