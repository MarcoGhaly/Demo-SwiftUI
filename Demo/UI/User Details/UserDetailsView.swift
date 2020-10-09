//
//  UserDetailsView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct UserDetailsView: View {
    
    var user: User
    
    var body: some View {
        VStack {
            MapView(coordinate: user.address?.geo ?? Geo(lat: "0", lng: "0")).frame(height: 300)
            UserRowView(user: user)
            Spacer()
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        return UserDetailsView(user: testUser)
    }
}
