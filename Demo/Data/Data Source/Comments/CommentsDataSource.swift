//
//  CommentsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol CommentsDataSource: DemoDataSource {
    func getComments(postID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Comment], DefaultAPIError>
}
