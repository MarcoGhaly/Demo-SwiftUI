//
//  AlbumsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 11/17/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class AlbumsViewModel: LCEListViewModel<Album> {
    private var userID: Int?
    
    init(userID: Int? = nil) {
        self.userID = userID
        super.init(limit: 20)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Album], DefaultAppError> {
        DemoDataSource().getAlbums(userID: userID, page: page, limit: limit)
    }
}
