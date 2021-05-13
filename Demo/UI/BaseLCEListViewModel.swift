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

class BaseLCEListViewModel<Element: Object & Identified & Codable, DataSource: DemoDataSource>: LCEListViewModel<Element> {
    let dataSource: DataSource
    
    init(dataSource: DataSource, models: [Element]? = nil, limit: Int? = nil) {
        self.dataSource = dataSource
        super.init(models: models, limit: limit)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Element], DefaultAPIError> {
        dataSource.getData(page: page, limit: limit)
    }
    
    func add(object: Element) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        dataSource.add(object: object).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] object in
            self?.model?.insert(object, at: 0)
        }
        .store(in: &subscriptions)
    }
    
    func deleteObjects(withIDs ids: Set<Int>) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        let objects = ids.compactMap { objectID in
            model?.first { $0.id == objectID }
        }
        
        dataSource.remove(objects: objects).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] _ in
            self?.model?.removeAll { ids.contains($0.id) }
        }
        .store(in: &subscriptions)
    }
}
