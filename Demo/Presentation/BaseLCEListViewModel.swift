//
//  BaseLCEListViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 31/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine
import RealmSwift

class BaseLCEListViewModel<Element: Object & Identified & Codable, UseCases: DemoUseCases>: LCEListViewModel<Element> {
    let useCases: UseCases
    
    let actionPublisher = PassthroughSubject<Action, Never>()
    
    init(useCases: UseCases, models: [Element]? = nil, limit: Int? = nil) {
        self.useCases = useCases
        super.init(models: models, limit: limit)
    }
}

// MARK: - Action
extension BaseLCEListViewModel {
    enum Action {
        case add
        case delete(IDs: Set<Int>)
    }
}
