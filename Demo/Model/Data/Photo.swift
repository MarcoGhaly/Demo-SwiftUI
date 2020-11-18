//
//  Photo.swift
//  Demo
//
//  Created by Marco Ghaly on 11/18/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

struct Photo: Codable, Identifiable {
    
    let albumId : Int?
    let id : Int?
    let title : String?
    let url : String?
    let thumbnailUrl : String?
    
}
