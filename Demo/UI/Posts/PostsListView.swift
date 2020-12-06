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
        LCEListView(viewModel: viewModel) { post in
            NavigationLink(destination: NavigationLazyView(PostDetailsView(viewModel: PostViewModel(post: post)))) {
                VStack {
                    PostRowView(post: post)
                    Divider()
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
        viewModel.viewState = .content
        return PostsListView(viewModel: viewModel)
    }
}
