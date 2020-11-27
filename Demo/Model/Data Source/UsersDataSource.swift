//
//  UsersDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

struct UsersDataSource: BaseDataSource {
    
    func getAllUsers(page: Int?, limit: Int?) -> AnyPublisher<[User], DefaultAppError> {
        var queryParameters = [String: String]()
        page.map { queryParameters["_page"] = String($0) }
        limit.map { queryParameters["_limit"] = String($0) }
        
        let request = Request(url: "users", queryParameters: queryParameters)
        return performRequest(request)
    }
    
}
