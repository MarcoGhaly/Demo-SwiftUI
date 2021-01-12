//
//  AlbumsRepository.swift
//  Demo
//
//  Created by Marco Ghaly on 12/01/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class AlbumsRepository: AlbumsDataSource {
    var methodName: String { "albums" }
    
    var idKey: String { "NextAlbumID" }
    
    var subscriptions: [AnyCancellable] = []
    
    func getAlbums(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Album], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        return getData(queryParameters: queryParameters, page: page, limit: limit)
    }
}
