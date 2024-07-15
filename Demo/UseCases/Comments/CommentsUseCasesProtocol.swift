//
//  CommentsUseCasesProtocol.swift
//  Demo
//
//  Created by Marco Ghaly on 15.07.24.
//  Copyright © 2024 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol CommentsUseCasesProtocol: DemoUseCases {
    func getComments(postID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Comment], DefaultAPIError>
    func add(comment: Comment) -> AnyPublisher<Comment, DefaultAPIError>
    func delete(comments: [Comment]) -> AnyPublisher<Void, DefaultAPIError>
}
