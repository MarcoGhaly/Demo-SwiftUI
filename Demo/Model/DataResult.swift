//
//  Result.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

struct DataResult<Data> {
    
    var success: Bool
    var data: Data?
    var error: Error?
    
}
