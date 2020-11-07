//
//  LCEViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 11/7/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class LCEViewModel<Model>: ObservableObject {
    
    // MARK:- Constants
    
    enum State: Equatable {
        case loading
        case content
        case error(title: String?, message: String?)
    }
    
    // MARK:- Variables
    
    var subscriptions: [AnyCancellable] = []
    
    @Published var state = State.loading
    
    lazy var receiveCompletion = { [weak self] (completion: Subscribers.Completion<AppError>) in
        switch completion {
        case .finished:
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self?.state = .content
            }
        case .failure(let error):
            self?.state = .error(title: "An Error Occurred", message: error.localizedDescription)
        }
    }
    
    @Published var model: Model
    
    // MARK:- Initializers
    
    init(model: Model, publisher: AnyPublisher<Model, AppError>? = nil) {
        self.model = model
        if let publisher = publisher {
            fetchData(publisher: publisher)
        }
    }
    
    func fetchData(publisher: AnyPublisher<Model, AppError>) {
        state = .loading
        
        publisher.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: receiveCompletion) { [weak self] (users) in
                self?.model = users
            }.store(in: &subscriptions)
        
    }
    
}
