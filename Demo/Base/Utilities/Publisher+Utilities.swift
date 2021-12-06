//
//  Publisher+Utilities.swift
//  Demo
//
//  Created by Marco Ghaly on 27/04/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    func share<Subject>(to subject: Subject) -> AnyCancellable where Subject: Combine.Subject, Subject.Output == Self.Output, Subject.Failure == Self.Failure {
        return sink {
            subject.send(completion: $0)
        } receiveValue: {
            subject.send($0)
        }
    }
}
