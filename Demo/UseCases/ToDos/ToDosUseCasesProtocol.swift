//
//  ToDosUseCasesProtocol.swift
//  Demo
//
//  Created by Marco Ghaly on 15.07.24.
//  Copyright © 2024 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

protocol ToDosUseCasesProtocol: DemoUseCases {
    func getToDos(userID: Int?, page: Int?, limit: Int?) -> AnyPublisher<[ToDo], DefaultAPIError>
    func add(toDo: ToDo) -> AnyPublisher<ToDo, DefaultAPIError>
    func delete(toDos: [ToDo]) -> AnyPublisher<Void, DefaultAPIError>
}
