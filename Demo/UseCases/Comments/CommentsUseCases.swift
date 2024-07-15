//
//  CommentsUseCases.swift
//  Demo
//
//  Created by Marco Ghaly on 15.07.24.
//  Copyright © 2024 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class CommentsUseCases: CommentsUseCasesProtocol {
    var idKey: String { "NextCommentID" }
    
    let dataSource: CommentsDataSource

    var subscriptions: [AnyCancellable] = []
    
    init(dataSource: CommentsDataSource = CommentsRepository()) {
        self.dataSource = dataSource
    }
    
    func getComments(postID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[Comment], DefaultAPIError> {
        var publisher: AnyPublisher<[Comment], DefaultAPIError> = dataSource.getRemoteComments(postID: postID, page: page, limit: limit)
        
        if page == 1 {
            let localPublisher: AnyPublisher<[Comment], DefaultAPIError> = dataSource.getLocalComments(postID: postID)
            publisher = Publishers.CombineLatest(publisher, localPublisher).map { remoteComments, localComments in
                localComments + remoteComments
            }.eraseToAnyPublisher()
        }
        
        return publisher
            // Add a delay to see the loading view
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(comment: Comment) -> AnyPublisher<Comment, DefaultAPIError> {
        let publisher: AnyPublisher<ID, DefaultAPIError> = dataSource.addRemote(object: comment)
        return publisher.map { [weak self] id in
            guard let self else { return comment }
            let id = id.id ?? 1
            comment.id = getNextID(withInitialValue: id)
            return dataSource.addLocal(object: comment) ?? comment
        }
        .eraseToAnyPublisher()
        // Add a delay to see the loading view
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func delete(comments: [Comment]) -> AnyPublisher<Void, DefaultAPIError> {
        let publishers: [AnyPublisher<Void, DefaultAPIError>] = comments.map { comment in
            let publisher: AnyPublisher<EmptyResponse, DefaultAPIError> = dataSource.deleteRemote(object: comment)
            
            publisher.sink { _ in
            } receiveValue: { _ in
                let _: Comment? = self.dataSource.deleteLocal(object: comment)
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
