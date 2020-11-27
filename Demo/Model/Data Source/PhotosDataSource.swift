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
        var queryParameters = [String: String]()
        albumID.map { queryParameters["albumId"] = String($0) }
        
        let request = Request(url: "photos", queryParameters: queryParameters)
        return performRequest(request)
    }
    
}
