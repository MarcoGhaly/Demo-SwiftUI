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
    
    enum ViewState {
        case content
        case loading(model: LoadingViewModel)
        case error(model: ErrorViewModel)
    }
    
    // MARK:- Variables
    
    var subscriptions: [AnyCancellable] = []
    @Published var viewState = ViewState.content
    @Published var loading = false
    @Published var model: Model?
    
    // MARK:- Initializers
    
    init(model: Model? = nil) {
        if let model = model {
            self.model = model
        } else {
            viewState = .loading(model: loadingViewModel())
            fetchData()
        }
    }
    
    // MARK:- Loading & Error
    
    func loadingViewModel() -> LoadingViewModel {
        LoadingViewModel(style: .normal, title: "Loading...", message: "Please Wait")
    }
    
    func errorViewModel(fromError error: Error) -> ErrorViewModel {
        ErrorViewModel(title: "Error!", message: error.localizedDescription)
    }
    
    // MARK:- Fetch Data
    
    func dataPublisher() -> AnyPublisher<Model, DefaultAppError> {
        fatalError("Subclass must implement this publisher")
    }
    
    func fetchData() {
        dataPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.updateViewState(completion: completion)
                }
            }) { [weak self] (model) in
                self?.model = model
            }
            .store(in: &subscriptions)
    }
    
    func updateViewState(completion: Subscribers.Completion<DefaultAppError>) {
        switch completion {
        case .finished:
            viewState = .content
        case .failure(let error):
            viewState = .error(model: errorViewModel(fromError: error))
        }
    }
}
