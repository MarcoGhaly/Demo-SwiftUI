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
    
    @State private var isEditMode = false
    @State private var selectedIDs = Set<User.ID>()
    @State private var presentAddUserView = false
    @State private var newUser = User()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            DefaultLCEListView(viewModel: viewModel, isEditMode: isEditMode, selectedIDs: $selectedIDs) { user in
                NavigationLink(destination: NavigationLazyView(UserDetailsView(user: user))) {
                    HStack {
                        VStack {
                            UserRowView(user: user)
                            Divider()
                        }
                        
                        if isEditMode {
                            Image(systemName: selectedIDs.contains(user.id) ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                }.disabled(isEditMode)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.none)
            
            if isEditMode {
                HStack {
                    Button {
                        viewModel.deleteUsers(wihtIDs: selectedIDs)
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
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $presentAddUserView, content: {
            AddUserView(isPresented: $presentAddUserView) { user in
                viewModel.add(user: user)
                presentAddUserView = false
            }
        })
        .navigationBarTitle(Text("Users"))
        .navigationBarItems(trailing: HStack {
            Button(action: {
                selectedIDs = []
                withAnimation {
                    isEditMode.toggle()
                }
            }, label: {
                Image(systemName: isEditMode ? "multiply.circle.fill" : "pencil.circle.fill")
            })
            
            if !isEditMode {
                Button(action: {
                    withAnimation {
                        presentAddUserView = true
                    }
                }, label: {
                    Image(systemName: "note.text.badge.plus")
                })
            }
        })
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
