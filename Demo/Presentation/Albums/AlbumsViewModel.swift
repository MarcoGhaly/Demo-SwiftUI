//
//  AlbumsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 11/17/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class AlbumsViewModel<DataSource: AlbumsDataSource>: BaseLCEListViewModel<Album, DataSource> {
    let userID: Int?
    
    init(dataSource: DataSource, userID: Int? = nil, albums: [Album]? = nil) {
        self.userID = userID
        super.init(dataSource: dataSource, models: albums, limit: 20)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Album], DefaultAPIError> {
        dataSource.getAlbums(userID: userID, page: page, limit: limit)
    }
}
