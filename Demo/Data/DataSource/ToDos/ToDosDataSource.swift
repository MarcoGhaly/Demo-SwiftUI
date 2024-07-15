//
//  ToDosDataSource.swift
//  Demo
//
//  Created by Marco Ghaly on 10/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol ToDosDataSource: DemoDataSource {
    func getRemoteToDos(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[ToDo], DefaultAPIError>
    func getLocalToDos(userID: Int?) -> AnyPublisher<[ToDo], DefaultAPIError>
}
