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
    
    func getAllAlbums() -> AnyPublisher<[Album], DefaultAppError> {
        performRequest(withRelativeURL: "albums")
    }
    
}
