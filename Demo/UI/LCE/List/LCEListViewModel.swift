//
//  LCEListViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 25/11/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class LCEListViewModel<Element>: LCEViewModel<[Element]> {
    private var limit: Int?
    private var page = 1
    
    @Published var isLoading = false
    
    init(models: [Element]? = nil, limit: Int? = nil) {
        self.limit = limit
        super.init(model: models)
        
        $model.compactMap{$0}.sink { [weak self] model in
            if let limit = self?.limit, model.count < limit {
                self?.limit = nil
            }
        }.store(in: &subscriptions)
    }
    
    func emptyModelErrorViewModel() -> ErrorViewModel {
        ErrorViewModel(title: "No Data Found")
    }
    
    override func dataPublisher() -> AnyPublisher<[Element], DefaultAppError> {
        dataPublisher(page: page, limit: limit)
    }
    
    func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[Element], DefaultAppError> {
        fatalError("Subclass must implement this publisher")
    }
    
    override func updateViewState(completion: Subscribers.Completion<DefaultAppError>) {
        if case .finished = completion, model?.isEmpty == true {
            viewState = .error(model: emptyModelErrorViewModel())
        } else {
            super.updateViewState(completion: completion)
        }
    }
    
    private func fetchMoreData() {
        dataPublisher().sink { [weak self] completion in
            self?.isLoading = false
        } receiveValue: { [weak self] model in
            self?.model?.append(contentsOf: model)
        }
        .store(in: &subscriptions)
    }
    
    func scrolledToEnd() {
        if !isLoading && limit != nil {
            isLoading = true
            page += 1
            fetchMoreData()
            // TODO: Calling "objectWillChange" manually because it's not called after "isLoading" is updated (remove after fix)
            objectWillChange.send()
        }
    }
}
