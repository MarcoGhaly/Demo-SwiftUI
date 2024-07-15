//
//  AlbumsUseCasesProtocol.swift
//  Demo
//
//  Created by Marco Ghaly on 15.07.24.
//  Copyright © 2024 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol AlbumsUseCasesProtocol: DemoUseCases {
    func getAlbums(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Album], DefaultAPIError>
    func add(album: Album) -> AnyPublisher<Album, DefaultAPIError>
    func delete(albums: [Album]) -> AnyPublisher<Void, DefaultAPIError>
}
