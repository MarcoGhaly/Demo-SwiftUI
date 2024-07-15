//
//  UsersViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersViewModel<UseCases: UsersUseCases>: BaseLCEListViewModel<User, UseCases> {
    init(useCases: UseCases = UsersUseCases(), users: [User]? = nil) {
        super.init(useCases: useCases, models: users, limit: 5)
        setActions()
    }
    
    override func dataPublisher(page: Int, limit: Int?) -> AnyPublisher<[User], DefaultAPIError> {
        useCases.getUsers(page: page, limit: limit)
    }
    
    func add(user: User) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        useCases.add(user: user).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] user in
            self?.model?.insert(user, at: 0)
        }
        .store(in: &subscriptions)
    }
    
    private func deleteUsers(withIDs ids: Set<Int>) {
        viewState = .loading(model: LoadingViewModel(style: .dialog))
        
        let users = ids.compactMap { userID in
            model?.first { $0.id == userID }
        }
        
        useCases.delete(users: users).sink { [weak self] completion in
            self?.updateViewState(completion: completion)
        } receiveValue: { [weak self] _ in
            self?.model?.removeAll { ids.contains($0.id) }
        }
        .store(in: &subscriptions)
    }
    
    private func setActions() {
        actionPublisher.sink { [weak self] action in
            switch action {
            case .add:
                break
            case .delete(let IDs):
                self?.deleteUsers(withIDs: IDs)
            }
        }.store(in: &subscriptions)
    }
}
