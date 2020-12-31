//
//  PhotosDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PhotosDataSource: DemoDataSource {
    var methodName: String { "photos" }
    
    var idKey: String { "NextPhotoID" }
    
    var subscriptions: [AnyCancellable] = []
    
    func getPhotos(albumID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Photo], DefaultAppError> {
        var queryParameters = [String: String]()
        albumID.map { queryParameters["albumId"] = String($0) }
        
        var request = Request(url: methodName, queryParameters: queryParameters)
        return performRequest(&request, page: page, limit: limit)
    }
}
