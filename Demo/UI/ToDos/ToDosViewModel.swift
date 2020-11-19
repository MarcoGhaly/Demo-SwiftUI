//
//  ToDosViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

class ToDosViewModel: LCEViewModel<[ToDo]> {
    
    init() {
        let toDosDataSource = ToDosDataSource()
        super.init(model: [], publisher: toDosDataSource.getToDos())
    }
    
}
