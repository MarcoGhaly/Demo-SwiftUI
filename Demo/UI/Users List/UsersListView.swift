//
//  UsersListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct UsersListView: View {
    
    @ObservedObject var viewModel: UsersViewModel
    
    var body: some View {
        LCEView(viewModel: viewModel) {
            List(viewModel.model) { user in
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
        let viewModel = UsersViewModel()
        viewModel.model = [testUser]
        viewModel.state = .content
        return UsersListView(viewModel: viewModel)
    }
}
