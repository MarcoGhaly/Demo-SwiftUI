//
//  PhotosViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 11/18/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PhotosViewModel: LCEListViewModel<Photo> {
    private var albumID: Int?
    
    init(albumID: Int? = nil) {
        self.albumID = albumID
        super.init(limit: 50)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Photo], DefaultAppError> {
        DemoDataSource().getPhotos(albumID: albumID, page: page, limit: limit)
    }
}
