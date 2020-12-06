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
    
    @State private var presentAddPostView = false
    
    var body: some View {
        let userID = viewModel.userID
        
        ZStack {
            LCEListView(viewModel: viewModel) { post in
                NavigationLink(destination: NavigationLazyView(PostDetailsView(viewModel: PostViewModel(post: post)))) {
                    VStack {
                        PostRowView(post: post)
                        Divider()
                    }
                }
            }
            
            userID.map {
                AddPostView(isPresented: $presentAddPostView, userID: $0, onConfirm: { post in
                    viewModel.add(post: post)
                    withAnimation {
                        presentAddPostView = false
                    }
                })
            }
        }
        .navigationBarTitle(Text("Posts"))
        .if(userID != nil) {
            $0.navigationBarItems(trailing: Button(action: {
                withAnimation {
                    presentAddPostView = true
                }
            }, label: {
                Image(systemName: "note.text.badge.plus")
            }))
        }
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
