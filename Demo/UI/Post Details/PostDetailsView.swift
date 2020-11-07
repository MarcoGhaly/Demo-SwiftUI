//
//  PostDetailsView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct PostDetailsView: View {
    
    @ObservedObject var viewModel: PostViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            viewModel.post.title.map {
                Text($0).font(.headline)
            }
            viewModel.post.body.map {
                Text($0).font(.body)
            }
            
            Divider()
            
            Text("Comments:").font(.title)
            
            CommentsListView(viewModel: CommentsViewModel(postID: viewModel.post.id)).frame(maxHeight: .infinity)
        }.padding().navigationBarTitle(Text(viewModel.post.title ?? ""))
    }
}

struct PostDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PostViewModel(post: testPost)
        return PostDetailsView(viewModel: viewModel)
    }
}
