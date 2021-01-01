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
    
    @State private var isEditMode = false
    @State private var selectedIDs = Set<Post.ID>()
    @State private var presentAddPostView = false
    
    var body: some View {
        let userID = viewModel.userID
        
        ZStack(alignment: .bottom) {
            Color.clear
            
            DefaultLCEListView(viewModel: viewModel, isEditMode: isEditMode, selectedIDs: $selectedIDs) { post in
                cellView(forPost: post)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.none)
            
            if isEditMode {
                editView
            }
            
            userID.map { userID in
                AddPostView(isPresented: $presentAddPostView, onConfirm: { post in
                    post.userId = userID
                    viewModel.add(post: post)
                    withAnimation {
                        presentAddPostView = false
                    }
                })
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle(Text("Posts"))
        .if(userID != nil) {
            $0.navigationBarItems(trailing: navigationBarItems)
        }
    }
    
    private func cellView(forPost post: Post) -> some View {
        NavigationLink(destination: NavigationLazyView(PostDetailsView(viewModel: PostViewModel(post: post)))) {
            VStack {
                HStack {
                    PostRowView(post: post)
                    if isEditMode {
                        Image(systemName: selectedIDs.contains(post.id) ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                Divider()
            }
        }
        .disabled(isEditMode)
    }
    
    private var editView: some View {
        HStack {
            Button {
                viewModel.deletePosts(wihtIDs: selectedIDs)
                isEditMode = false
            } label: {
                VStack {
                    Image(systemName: "trash")
                    Text("Delete")
                }
            }
        }
        .disabled(selectedIDs.isEmpty)
        .frame(maxWidth: .infinity)
        .padding()
        .cardify()
        .transition(.move(edge: .bottom))
    }
    
    private var navigationBarItems: some View {
        HStack {
            if viewModel.model?.isEmpty == false {
                Button(action: {
                    selectedIDs = []
                    withAnimation {
                        isEditMode.toggle()
                    }
                }, label: {
                    Image(systemName: isEditMode ? "multiply.circle.fill" : "pencil.circle.fill")
                })
            }
            
            if !isEditMode {
                Button(action: {
                    withAnimation {
                        presentAddPostView = true
                    }
                }, label: {
                    Image(systemName: "note.text.badge.plus")
                })
            }
        }
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
