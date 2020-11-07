//
//  HomeView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    private let buttons =
        [[("Users", Color.red, {AnyView(UsersListView().environmentObject(UsersStore()))}),
          ("Posts", Color.green, {AnyView(PostsListView().environmentObject(PostsStore()))})],
         [("Comments", Color.blue, {AnyView(CommentsListView().environmentObject(CommentsStore()))}),
          ("ToDos", Color.yellow, {AnyView(ToDosListView().environmentObject(ToDosStore()))})],
         [("Albums", Color.gray, {AnyView(UsersListView().environmentObject(UsersStore()))}),
          ("Photos", Color.black, {AnyView(UsersListView().environmentObject(UsersStore()))})]]
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(buttons, id: \.self[0].0) { array in
                    HStack(spacing: 0) {
                        ForEach(array, id: \.self.0) { button in
                            NavigationLink(destination: NavigationLazyView(button.2())) {
                                Text(button.0).frame(maxWidth: .infinity, maxHeight: .infinity).font(.title).background(button.1).foregroundColor(.white)
                            }
                        }
                    }
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
