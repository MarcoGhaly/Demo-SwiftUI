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
    
    enum ViewState: Equatable {
        case loading
        case content
        case error(title: String?, message: String?)
    }
    
    private static var generalErrorText: String {
        "An Error Occurred"
    }
    
    // MARK:- Variables
    
    var subscriptions: [AnyCancellable] = []
    @Published var viewState = ViewState.loading
    @Published var loading = false
    @Published var model: Model?
    
    // MARK:- Initializers
    
    init(model: Model? = nil) {
        if let model = model {
            self.model = model
        } else {
            viewState = .loading
            fetchData()
        }
    }
    
    // MARK:- Fetch Data
    
    func dataPublisher() -> AnyPublisher<Model, DefaultAppError> {
        fatalError("Subclass must implement this publisher")
    }
    
    func fetchData() {
        dataPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.viewState = .content
                    }
                case .failure(let error):
                    self?.viewState = .error(title: LCEViewModel.generalErrorText, message: error.localizedDescription)
                }
            }) { [weak self] (model) in
                self?.model = model
            }
            .store(in: &subscriptions)
    }
}
