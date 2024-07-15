//
//  AlbumsDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol AlbumsDataSource: DemoDataSource {
    func getRemoteAlbums(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Album], DefaultAPIError>
    func getLocalAlbums(userID: Int?) -> AnyPublisher<[Album], DefaultAPIError>
}
