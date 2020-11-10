//
//  CommentsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

struct CommentsDataSource: BaseDataSource {
    
    func getComments(postID: Int? = nil) -> AnyPublisher<[Comment], DefaultAppError> {
        var urlString = "comments"
        postID.map {
            urlString += "?postId=\($0)"
        }
        return performRequest(withRelativeURL: urlString)
    }
    
}
