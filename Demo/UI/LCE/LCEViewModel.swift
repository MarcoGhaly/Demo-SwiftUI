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
    
    lazy var receiveCompletion = { [weak self] (completion: Subscribers.Completion<DefaultAppError>) in
        switch completion {
        case .finished:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.state = .content
            }
        case .failure(let error):
            self?.state = .error(title: "An Error Occurred", message: error.localizedDescription)
        }
    }
    
    @Published var model: Model?
    
    // MARK:- Initializers
    
    init(model: Model? = nil) {
        if let model = model {
            self.model = model
        } else {
            fetchData()
        }
    }
    
    // MARK:- Fetch Data
    
    func dataPublisher() -> AnyPublisher<Model, DefaultAppError> {
        fatalError("Subclass must implement this publisher")
    }
    
    func fetchData() {
        state = .loading
        
        dataPublisher().receive(on: DispatchQueue.main)
            .sink(receiveCompletion: receiveCompletion) { [weak self] (users) in
                self?.model = users
            }.store(in: &subscriptions)
    }
    
}
