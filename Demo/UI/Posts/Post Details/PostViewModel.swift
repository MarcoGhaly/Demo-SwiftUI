//
//  PostViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 11/7/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var post: Post
    
    init(post: Post) {
        self.post = post
    }
}
