//
//  PhotosDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 11/18/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

struct PhotosDataSource: BaseDataSource {
    
    func getPhotos(albumID: Int? = nil) -> AnyPublisher<[Photo], DefaultAppError> {
        var urlString = "photos"
        albumID.map { urlString += "?albumId=\($0)" }
        return performRequest(withRelativeURL: urlString)
    }
    
}
