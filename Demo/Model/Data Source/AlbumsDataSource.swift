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
        var urlString = "albums"
        userID.map { urlString += "?userId=\($0)" }
        return performRequest(withRelativeURL: urlString)
    }
    
}
