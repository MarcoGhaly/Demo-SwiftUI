//
//  PostViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

class PostDetailsViewModel: ObservableObject {
    
    @Published var post: Post
    @Published var loading = false
    
    init(post: Post) {
        self.post = post
    }
    
}
