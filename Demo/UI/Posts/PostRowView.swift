//
//  PostRowView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct PostRowView: View {
    
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            post.title.map {
                Text($0).font(.headline)
                }?.padding(.bottom, 20)
            post.body.map {
                Text($0).font(.subheadline)
            }
        }.padding()
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        return PostRowView(post: testPost).previewLayout(.sizeThatFits)
    }
}
