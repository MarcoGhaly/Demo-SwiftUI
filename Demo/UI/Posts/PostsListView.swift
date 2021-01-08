//
//  PostsListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/29/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct PostsListView<DataSource: PostsDataSource>: View {
    @ObservedObject var viewModel: PostsViewModel<DataSource>
    
    @State private var presentAddPostView = false
    
    var body: some View {
        let userID = viewModel.userID
        
        ZStack(alignment: .bottom) {
            Color.clear
            
            BaseLCEListView(viewModel: viewModel, showNavigationBarItems: userID != nil, presentAddView: $presentAddPostView) { post in
                PostRowView(post: post)
            } destination: { post in
                PostDetailsView(viewModel: PostViewModel(post: post))
            }
            
            userID.map { userID in
                AddPostView(isPresented: $presentAddPostView, onConfirm: { post in
                    post.userId = userID
                    viewModel.add(object: post)
                    withAnimation {
                        presentAddPostView = false
                    }
                })
            }
        }
        .navigationBarTitle(Text("Posts"))
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PostsViewModel(dataSource: PostsRepository())
        viewModel.model = [testPost]
        viewModel.viewState = .content
        return PostsListView(viewModel: viewModel)
    }
}
