//
//  UsersListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct UsersListView<UseCases: UsersUseCases>: View {
    @ObservedObject var viewModel: UsersViewModel<UseCases>
    
    @State private var presentAddUserView = false
    
    var body: some View {
        BaseLCEListView(viewModel: viewModel, presentAddView: $presentAddUserView) { user in
            UserRowView(user: user)
        } destination: { user in
            UserDetailsView(user: user)
        }
        .navigationBarTitle("Users")
        .sheet(isPresented: $presentAddUserView, content: {
            AddUserView(isPresented: $presentAddUserView) { user in
                viewModel.add(user: user)
                presentAddUserView = false
            }
        })
    }
}

//struct UsersListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = UsersViewModel(useCases: <#T##UsersUseCases#>)
//        viewModel.model = [testUser]
//        viewModel.viewState = .content
//        return UsersListView(viewModel: viewModel)
//    }
//}
