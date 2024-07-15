//
//  PhotosDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol PhotosDataSource: DemoDataSource {
    func getRemotePhotos(albumID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Photo], DefaultAPIError>
    func getLocalPhotos(albumID: Int?) -> AnyPublisher<[Photo], DefaultAPIError>
}
