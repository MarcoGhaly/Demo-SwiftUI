//
//  PostsListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct PostsListView: View {
    
    @ObservedObject var viewModel: PostsViewModel
    
    var body: some View {
        LCEView(viewModel: viewModel) {
            List(viewModel.model) { post in
                NavigationLink(destination: PostDetailsView().environmentObject(PostViewModel(post: post))) {
                    PostRowView(post: post)
                }
            }
        }
        .navigationBarTitle(Text("Posts"))
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PostsViewModel()
        viewModel.model = [testPost]
        viewModel.state = .content
        return PostsListView(viewModel: viewModel)
    }
}
