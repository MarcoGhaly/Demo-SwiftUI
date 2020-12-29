//
//  CommentsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class CommentsDataSource: BaseDemoDataSource {
    func getComments(postID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Comment], DefaultAppError> {
        var queryParameters = [String: String]()
        postID.map { queryParameters["postId"] = String($0) }
        
        var request = Request(url: "comments", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
}
