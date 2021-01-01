//
//  UsersListView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct UsersListView<DataSource: UsersDataSource>: View {
    @ObservedObject var viewModel: UsersViewModel<DataSource>
    
    @State private var isEditMode = false
    @State private var selectedIDs = Set<User.ID>()
    @State private var presentAddUserView = false
    @State private var newUser = User()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            DefaultLCEListView(viewModel: viewModel, isEditMode: isEditMode, selectedIDs: $selectedIDs) { user in
                cellView(forUser: user)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.none)
            
            if isEditMode {
                editView
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle(Text("Users"))
        .navigationBarItems(trailing: navigationBarItems)
        .sheet(isPresented: $presentAddUserView, content: {
            AddUserView(isPresented: $presentAddUserView) { user in
                viewModel.add(user: user)
                presentAddUserView = false
            }
        })
    }
    
    private func cellView(forUser user: User) -> some View {
        NavigationLink(destination: NavigationLazyView(UserDetailsView(user: user))) {
            VStack {
                HStack {
                    UserRowView(user: user)
                    if isEditMode {
                        Image(systemName: selectedIDs.contains(user.id) ? "checkmark.circle.fill" : "circle")
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
                viewModel.deleteUsers(wihtIDs: selectedIDs)
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
                        presentAddUserView = true
                    }
                }, label: {
                    Image(systemName: "note.text.badge.plus")
                })
            }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = UsersViewModel(dataSource: UsersRepository())
        viewModel.model = [testUser]
        viewModel.viewState = .content
        return UsersListView(viewModel: viewModel)
    }
}
