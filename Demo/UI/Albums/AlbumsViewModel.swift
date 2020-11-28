//
//  AlbumsViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 11/17/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class AlbumsViewModel: LCEViewModel<[Album]> {
    
    private var userID: Int?
    
    init(userID: Int? = nil) {
        self.userID = userID
    }
    
    override func dataPublisher() -> AnyPublisher<[Album], DefaultAppError> {
        DemoDataSource().getAlbums(userID: userID)
    }
    
}
