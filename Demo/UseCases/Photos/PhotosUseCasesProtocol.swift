//
//  PhotosUseCasesProtocol.swift
//  Demo
//
//  Created by Marco Ghaly on 15.07.24.
//  Copyright © 2024 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol PhotosUseCasesProtocol: DemoUseCases {
    func getPhotos(albumID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Photo], DefaultAPIError>
    func add(photo: Photo) -> AnyPublisher<Photo, DefaultAPIError>
    func delete(photos: [Photo]) -> AnyPublisher<Void, DefaultAPIError>
}
