//
//  UsersListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct UsersListView: View {
    
    @ObservedObject var usersStore: UsersStore
    
    var body: some View {
        LCEView(viewModel: usersStore) {
            List(usersStore.model) { user in
                NavigationLink(destination: UserDetailsView(user: user)) {
                    UserRowView(user: user)
                }
            }
        }
        .navigationBarTitle(Text("Users"))
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        let usersStore = UsersStore()
        usersStore.model = [testUser]
        usersStore.state = .content
        return UsersListView(usersStore: usersStore)
    }
}
