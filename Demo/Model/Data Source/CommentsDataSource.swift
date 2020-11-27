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
        var queryParameters = [String: String]()
        postID.map { queryParameters["postId"] = String($0) }
        
        let request = Request(url: "comments", queryParameters: queryParameters)
        return performRequest(request)
    }
    
}
