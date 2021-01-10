//
//  HomeView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    private let spacing: CGFloat = 20
    
    private let buttons =
        [("Users", AnyView(UsersListView(viewModel: UsersViewModel(dataSource: UsersRepository())))),
         ("Posts", AnyView(PostsListView(viewModel: PostsViewModel(dataSource: PostsRepository())))),
         ("Comments", AnyView(CommentsListView(viewModel: CommentsViewModel()))),
         ("ToDos", AnyView(ToDosListView(viewModel: ToDosViewModel()))),
         ("Albums", AnyView(AlbumsListView(viewModel: AlbumsViewModel()))),
         ("Photos", AnyView(PhotosListView(viewModel: PhotosViewModel())))]
    
    var body: some View {
        NavigationView {
            GridView(elements: buttons, columns: 2, spacing: spacing) { button in
                NavigationLink(destination: NavigationLazyView(button.1)) {
                    Text(button.0)
                        .font(.title)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(.black)
                        .cardify()
                }
            }
            .navigationBarTitle("Home")
            .navigationBarHidden(true)
            .padding(spacing)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
