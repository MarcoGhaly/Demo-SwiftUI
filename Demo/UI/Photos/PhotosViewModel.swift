//
//  PhotosViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 11/18/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

class PhotosViewModel: LCEViewModel<[Photo]> {
    
    init(albumID: Int? = nil) {
        let photosDataSource = PhotosDataSource()
        super.init(model: [], publisher: photosDataSource.getPhotos(albumID: albumID))
    }
    
}
