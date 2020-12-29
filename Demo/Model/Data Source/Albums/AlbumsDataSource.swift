//
//  AlbumsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class AlbumsDataSource: BaseDemoDataSource {
    func getAlbums(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Album], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        var request = Request(url: "albums", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
}
