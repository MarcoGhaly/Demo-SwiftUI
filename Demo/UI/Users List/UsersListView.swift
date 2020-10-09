//
//  UsersListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct UsersListView: View {
    
    @EnvironmentObject var usersStore: UsersStore
    
    var body: some View {
        ZStack {
            if usersStore.loading {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            } else {
                List(usersStore.users) { user in
                    NavigationLink(destination: UserDetailsView(user: user)) {
                        UserRowView(user: user)
                    }
                }
            }
        }.navigationBarTitle(Text("Users")).onAppear {
            if self.usersStore.users.isEmpty {
                self.usersStore.fetchUsers()
            }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        let usersStore = UsersStore()
        usersStore.users = [testUser]
        usersStore.loading = false
        return UsersListView().environmentObject(usersStore)
    }
}
