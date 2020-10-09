//
//  ToDosStore.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class ToDosStore: ObservableObject {
    
    @Published var toDos: [ToDo] = []
    @Published var loading = false
    var subscriptions: [AnyCancellable] = []
    
    func fetchToDos() {
        loading = true
        let toDosDataSource = ToDosDataSource()
        
        toDosDataSource.getToDos()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    break
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.loading = false
                }
            }, receiveValue: { [weak self] (toDos) in
                self?.toDos = toDos
            }).store(in: &subscriptions)
    }
    
}
