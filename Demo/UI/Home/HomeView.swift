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
        [("Users", "person.fill", {UsersListView(viewModel: UsersViewModel(dataSource: UsersRepository())).toAnyView()}),
         ("Posts", "envelope.fill", {PostsListView(viewModel: PostsViewModel(dataSource: PostsRepository())).toAnyView()}),
         ("Comments", "message.fill", {CommentsListView(viewModel: CommentsViewModel(dataSource: CommentsRepository())).toAnyView()}),
         ("ToDos", "checkmark.circle.fill", {ToDosListView(viewModel: ToDosViewModel(dataSource: ToDosRepository())).toAnyView()}),
         ("Albums", "photo.fill", {AlbumsListView(viewModel: AlbumsViewModel(dataSource: AlbumsRepository())).toAnyView()})]
    
    var body: some View {
        TabView {
            ForEach(buttons, id: \.self.0) { button in
                NavigationView {
                    NavigationLazyView(button.2())
                }
                .tabItem {
                    Image(systemName: button.1)
                    Text(button.0)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
