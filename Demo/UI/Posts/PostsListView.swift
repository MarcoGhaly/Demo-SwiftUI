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
    
    @State private var isEditMode = false
    @State private var selectedIndices = Set<Post.ID>()
    @State private var presentAddPostView = false
    
    var body: some View {
        let userID = viewModel.userID
        
        ZStack {
            DefaultLCEListView(viewModel: viewModel, isEditMode: isEditMode, selectedIndices: $selectedIndices) { post in
                NavigationLink(destination: NavigationLazyView(PostDetailsView(viewModel: PostViewModel(post: post)))) {
                    HStack {
                        VStack {
                            PostRowView(post: post)
                            Divider()
                        }
                        if isEditMode {
                            Image(systemName: selectedIndices.contains(post.id) ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                }.disabled(isEditMode)
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
            $0.navigationBarItems(trailing: HStack {
                Button(action: {
                    selectedIndices = []
                    isEditMode.toggle()
                }, label: {
                    Image(systemName: isEditMode ? "multiply.circle.fill" : "pencil.circle.fill")
                })
                
                Button(action: {
                    withAnimation {
                        presentAddPostView = true
                    }
                }, label: {
                    Image(systemName: "note.text.badge.plus")
                })
            })
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
