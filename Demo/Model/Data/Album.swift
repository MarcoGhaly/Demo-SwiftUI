//
//  Album.swift
//  Demo
//
//  Created by Marco Ghaly on 11/17/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

struct Album: Codable, Identifiable {
    
    let id : Int?
    let userId : Int?
    let title : String?
    
}
