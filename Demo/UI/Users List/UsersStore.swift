//
//  UsersStore.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersStore: ObservableObject {
    
    @Published var users: [User] = []
    @Published var loading = false
    var subscriptions: [AnyCancellable] = []
    
    func fetchUsers() {
        loading = true
        let usersDataSource = UsersDataSource()
        
        usersDataSource.getAllUsers()
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
            }) { [weak self] (users) in
                self?.users = users
        }.store(in: &subscriptions)
    }
    
}
