//
//  UsersViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersViewModel: LCEListViewModel<User> {
    private let dataSource: UsersDataSource
    
    init(dataSource: UsersDataSource) {
        self.dataSource = dataSource
        super.init(limit: 5)
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[User], DefaultAppError> {
        dataSource.getUsers(page: page, limit: limit)
    }
    
    func add(user: User) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        dataSource.add(user: user).sink { [weak self] completion in
            self?.viewState = .content
        } receiveValue: { [weak self] user in
            self?.model?.insert(user, at: 0)
        }
        .store(in: &subscriptions)
    }
    
    func deleteUsers(wihtIDs usersIDs: Set<User.ID>) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        let users = usersIDs.compactMap { userID in
            model?.first { $0.id == userID }
        }
        
        dataSource.remove(users: users).sink { [weak self] _ in
            self?.viewState = .content
        } receiveValue: { [weak self] _ in
            self?.model?.removeAll { usersIDs.contains($0.id) }
        }
        .store(in: &subscriptions)
    }
}
