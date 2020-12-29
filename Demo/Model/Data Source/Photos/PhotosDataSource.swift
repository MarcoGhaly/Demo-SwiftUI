//
//  PhotosDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PhotosDataSource: BaseDemoDataSource {
    func getPhotos(albumID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Photo], DefaultAppError> {
        var queryParameters = [String: String]()
        albumID.map { queryParameters["albumId"] = String($0) }
        
        var request = Request(url: "photos", queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
}
