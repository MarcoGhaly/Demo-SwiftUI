//
//  AlbumsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 11/17/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

struct AlbumsDataSource: BaseDataSource {
    
    func getAlbums(userID: Int? = nil) -> AnyPublisher<[Album], DefaultAppError> {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        
        let request = Request(url: "albums", queryParameters: queryParameters)
        return performRequest(request)
    }
    
}
