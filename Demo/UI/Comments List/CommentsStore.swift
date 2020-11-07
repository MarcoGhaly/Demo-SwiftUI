//
//  CommentsStore.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class CommentsStore: LCEViewModel<[Comment]> {
    
    init(postID: Int? = nil) {
        let commentsDataSource = CommentsDataSource()
        super.init(model: [], publisher: commentsDataSource.getComments(postID: postID))
    }
    
}
