//
//  TestDataSource.swift
//  DemoTests
//
//  Created by Marco Ghaly on 31/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine
import RealmSwift
@testable import Demo

class TestDataSource: DemoDataSource {
    var methodName: String = ""
    var idKey: String = ""
    var subscriptions: [AnyCancellable] = []
    
    func add<T>(object: T) -> AnyPublisher<T, DefaultAppError> where T : Object, T : Identified, T : Encodable {
        let publisher = PassthroughSubject<T, DefaultAppError>()
        DispatchQueue.main.async {
            publisher.send(object)
            publisher.send(completion: .finished)
        }
        return publisher.eraseToAnyPublisher()
    }
    
    func remove<T>(objects: [T]) -> AnyPublisher<Void, DefaultAppError> where T : Object, T : Identified {
        let publisher = PassthroughSubject<Void, DefaultAppError>()
        DispatchQueue.main.async {
            publisher.send()
            publisher.send(completion: .finished)
        }
        return publisher.eraseToAnyPublisher()
    }
}