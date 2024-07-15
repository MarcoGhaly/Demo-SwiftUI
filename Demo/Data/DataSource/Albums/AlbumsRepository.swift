//
//  AlbumsRepository.swift
//  Demo
//
//  Created by Marco Ghaly on 12/01/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class AlbumsRepository: AlbumsDataSource {
    let networkAgent: NetworkAgentProtocol
    var methodName: String { "albums" }
    
    init(networkAgent: NetworkAgentProtocol = NetworkAgent()) {
        self.networkAgent = networkAgent
    }
    
    func getRemoteAlbums(userID: Int? = nil, page: Int? = nil, limit: Int? = nil) -> AnyPublisher<[Album], DefaultAPIError> {
        let queryParameters = queryParameters(from: userID)
        return getRemoteData(queryParameters: queryParameters, page: page, limit: limit)
    }
    
    func getLocalAlbums(userID: Int?) -> AnyPublisher<[Album], DefaultAPIError> {
        let queryParameters = queryParameters(from: userID)
        return getLocalData(queryParameters: queryParameters)
    }
}

private extension AlbumsRepository {
    func queryParameters(from userID: Int?) -> [String: String] {
        var queryParameters = [String: String]()
        userID.map { queryParameters["userId"] = String($0) }
        return queryParameters
    }
}
