//
//  UserRowView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct UserRowView: View {
    
    var user: User
    
    var body: some View {
        VStack {
            HStack {
                Text("Name:").font(.subheadline)
                user.name.map {
                    Text($0).font(.subheadline)
                }
                Spacer()
            }
            HStack {
                Text("Email:").font(.subheadline)
                user.email.map {
                    Text($0).font(.subheadline)
                }
                Spacer()
            }
            HStack {
                Text("Phone:").font(.subheadline)
                user.phone.map {
                    Text($0).font(.subheadline)
                }
                Spacer()
            }
            HStack {
                Text("Address:").font(.subheadline)
                user.address.map { address in
                    Text(address.description).font(.subheadline)
                }
                Spacer()
            }
            HStack {
                Text("Website:").font(.subheadline)
                user.website.map {
                    Text($0).font(.subheadline)
                }
                Spacer()
            }
            HStack {
                Text("Company:").font(.subheadline)
                user.company?.name.map {
                    Text($0).font(.subheadline)
                }
                Spacer()
            }
        }.padding()
    }
}

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        return UserRowView(user: testUser).previewLayout(.sizeThatFits)
    }
}
