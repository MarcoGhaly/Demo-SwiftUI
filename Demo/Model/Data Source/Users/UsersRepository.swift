//
//  UsersRepository.swift
//  Demo
//
//  Created by Marco Ghaly on 28/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import Combine

class UsersRepository: UsersDataSource {
    var methodName: String { "users" }
    
    var idKey: String { "NextUserID" }
    
    var subscriptions: [AnyCancellable] = []
}
