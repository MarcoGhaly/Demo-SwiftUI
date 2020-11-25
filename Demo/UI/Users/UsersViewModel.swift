//
//  UsersViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersViewModel: LCEViewModel<[User]> {
    
    override func dataPublisher() -> AnyPublisher<[User], DefaultAppError> {
        UsersDataSource().getAllUsers()
    }
    
}
