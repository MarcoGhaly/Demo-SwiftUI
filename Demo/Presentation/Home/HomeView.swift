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

private extension HomeView {
    // Put views in closures to allow lazy navigation
    var buttons: [(String, String, () -> AnyView)] {
        [
            (
                "Users", "person.fill",
                { UsersListView(viewModel: UsersViewModel()).toAnyView() }
            ),
            (
                "Posts", "envelope.fill",
                { PostsListView(viewModel: PostsViewModel()).toAnyView() }
            ),
            (
                "Comments", "message.fill",
                { CommentsListView(viewModel: CommentsViewModel()).toAnyView() }),
            (
                "ToDos", "checkmark.circle.fill",
                { ToDosListView(viewModel: ToDosViewModel()).toAnyView() }
            ),
            (
                "Albums", "photo.fill",
                { AlbumsListView(viewModel: AlbumsViewModel()).toAnyView() }
            )
        ]
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
