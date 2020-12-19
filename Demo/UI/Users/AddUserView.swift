//
//  AddUserView.swift
//  Demo
//
//  Created by Marco Ghaly on 19/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

typealias Entry = (label: String, value: String, keyPath: WritableKeyPath<User, String?>)

struct AddUserView: View {
    @Binding var isPresented: Bool
    var onConfirm: (User) -> Void
    
    @State private var entries: [Entry] = [("Username", \User.username),
                                           ("Name", \User.name),
                                           ("Email", \User.email),
                                           ("Phone", \User.phone),
                                           ("Website", \User.website)]
        .map { Entry(label: $0.0, value: "", keyPath: $0.1) }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Add New User")
                    .font(.title)
                
                ForEach(entries.indices) { index in
                    EntryView(title: entries[index].label, placeHolder: entries[index].label, text: $entries[index].value)
                    Divider()
                }
                
                Button(action: {
                    var user = User()
                    entries.forEach { entry in
                        user[keyPath: entry.keyPath] = entry.value
                    }
                    onConfirm(user)
                }, label: {
                    Text("Add User")
                        .font(.title)
                })
                .disabled(entries.contains { $0.value.isEmpty })
            }
            .padding(.horizontal, 20)
        }
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView(isPresented: .constant(true), onConfirm: { user in })
            .previewLayout(.sizeThatFits)
    }
}
