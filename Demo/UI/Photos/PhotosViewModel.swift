//
//  PhotosViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 11/18/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PhotosViewModel<DataSource: PhotosDataSource>: BaseLCEListViewModel<Photo, DataSource> {
    private var albumID: Int?
    
    init(dataSource: DataSource, albumID: Int? = nil, photos: [Photo]? = nil) {
        self.albumID = albumID
        super.init(dataSource: dataSource, models: photos, limit: 50)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Photo], DefaultAppError> {
        PhotosDataSource().getPhotos(albumID: albumID, page: page, limit: limit)
    }
}
