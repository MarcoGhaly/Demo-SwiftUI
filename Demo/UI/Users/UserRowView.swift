//
//  UserRowView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct UserRowView: View {
    let user: User
    
    var body: some View {
        let info = [("Name:", user.name),
                    ("Email:", user.email),
                    ("Phone:", user.phone),
                    ("Address:", user.address?.description),
                    ("Website:", user.website),
                    ("Company:", user.company?.name)]
        
        return InfoView(info: info)
            .padding(.horizontal)
    }
}

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        return UserRowView(user: testUser)
            .previewLayout(.sizeThatFits)
    }
}
