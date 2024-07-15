//
//  PhotosUseCases.swift
//  Demo
//
//  Created by Marco Ghaly on 15.07.24.
//  Copyright © 2024 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class PhotosUseCases: PhotosUseCasesProtocol {
    var idKey: String { "NextPhotoID" }
    
    let dataSource: PhotosDataSource

    var subscriptions: [AnyCancellable] = []
    
    init(dataSource: PhotosDataSource = PhotosRepository()) {
        self.dataSource = dataSource
    }
    
    func getPhotos(albumID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Photo], DefaultAPIError> {
        var publisher: AnyPublisher<[Photo], DefaultAPIError> = dataSource.getRemotePhotos(albumID: albumID, page: page, limit: limit)
        
        if page == 1 {
            let localPublisher: AnyPublisher<[Photo], DefaultAPIError> = dataSource.getLocalPhotos(albumID: albumID)
            publisher = Publishers.CombineLatest(publisher, localPublisher).map { remotePhotos, localPhotos in
                localPhotos + remotePhotos
            }.eraseToAnyPublisher()
        }
        
        return publisher
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(photo: Photo) -> AnyPublisher<Photo, DefaultAPIError> {
        let publisher: AnyPublisher<ID, DefaultAPIError> = dataSource.addRemote(object: photo)
        return publisher.map { [weak self] id in
            guard let self else { return photo }
            let id = id.id ?? 1
            photo.id = getNextID(withInitialValue: id)
            return dataSource.addLocal(object: photo) ?? photo
        }
        .eraseToAnyPublisher()
        // Add a delay to see the loading view
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func delete(photos: [Photo]) -> AnyPublisher<Void, DefaultAPIError> {
        let publishers: [AnyPublisher<Void, DefaultAPIError>] = photos.map { photo in
            let publisher: AnyPublisher<EmptyResponse, DefaultAPIError> = dataSource.deleteRemote(object: photo)
            
            publisher.sink { _ in
            } receiveValue: { _ in
                let _: Photo? = self.dataSource.deleteLocal(object: photo)
            }
            .store(in: &subscriptions)
            
            return publisher.map { _ in () }
            .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(publishers)
            .reduce((), { (_, _) in () })
            .eraseToAnyPublisher()
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
