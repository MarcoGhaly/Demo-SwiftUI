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
    
    // Put views in closures to allow lazy navigation
    private let buttons =
        [("Users", {UsersListView(viewModel: UsersViewModel(dataSource: UsersRepository())).toAnyView()}),
         ("Posts", {PostsListView(viewModel: PostsViewModel(dataSource: PostsRepository())).toAnyView()}),
         ("Comments", {CommentsListView(viewModel: CommentsViewModel()).toAnyView()}),
         ("ToDos", {ToDosListView(viewModel: ToDosViewModel()).toAnyView()}),
         ("Albums", {AlbumsListView(viewModel: AlbumsViewModel()).toAnyView()}),
         ("Photos", {PhotosListView(viewModel: PhotosViewModel(dataSource: PhotosDataSource())).toAnyView()})]
    
    var body: some View {
        NavigationView {
            GridView(elements: buttons, columns: 2, spacing: spacing) { button in
                NavigationLink(destination: NavigationLazyView(button.1())) {
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
