//
//  PhotosRepository.swift
//  Demo
//
//  Created by Marco Ghaly on 12/01/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PhotosRepository: PhotosDataSource {
    var methodName: String { "photos" }
    
    var idKey: String { "NextPhotoID" }
    
    var subscriptions: [AnyCancellable] = []
    
    func getPhotos(albumID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Photo], DefaultAPIError> {
        var queryParameters = [String: String]()
        albumID.map { queryParameters["albumId"] = String($0) }
        return getData(queryParameters: queryParameters, page: page, limit: limit)
    }
}
