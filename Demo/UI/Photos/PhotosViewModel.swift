//
//  PhotosViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 11/18/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PhotosViewModel: LCEViewModel<[Photo]> {
    
    private var albumID: Int?
    
    init(albumID: Int? = nil) {
        self.albumID = albumID
    }
    
    override func dataPublisher() -> AnyPublisher<[Photo], DefaultAppError> {
        DemoDataSource().getPhotos(albumID: albumID)
    }
    
}
