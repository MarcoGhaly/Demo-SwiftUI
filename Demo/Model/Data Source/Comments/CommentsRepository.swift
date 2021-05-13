//
//  CommentsRepository.swift
//  Demo
//
//  Created by Marco Ghaly on 12/01/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class CommentsRepository: CommentsDataSource {
    var methodName: String { "comments" }
    
    var idKey: String { "NextCommentID" }
    
    var subscriptions: [AnyCancellable] = []
    
    func getComments(postID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Comment], DefaultAPIError> {
        var queryParameters = [String: String]()
        postID.map { queryParameters["postId"] = String($0) }
        return getData(queryParameters: queryParameters, page: page, limit: limit)
    }
}
