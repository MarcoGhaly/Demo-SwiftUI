//
//  UserDetailsView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct UserDetailsView: View {
    let user: User
    
    // Put views in closures to allow lazy navigation
    private var buttons: [(String, () -> AnyView)] {
        [("Posts", {PostsListView(viewModel: PostsViewModel(dataSource: PostsRepository(), userID: user.id)).toAnyView()}),
         ("ToDos", {ToDosListView(viewModel: ToDosViewModel(dataSource: ToDosRepository(), userID: user.id)).toAnyView()}),
         ("Albums", {AlbumsListView(viewModel: AlbumsViewModel(dataSource: AlbumsRepository(), userID: user.id)).toAnyView()})]
    }
    
    var body: some View {
        VStack {
            MapView(coordinate: coordinateToCoordinate2D(coordinate: user.address?.geo))
            UserRowView(user: user)
            
            Divider()
            
            ForEach(buttons, id: \.self.0) { button in
                VStack(spacing: 0) {
                    NavigationLink(
                        destination: NavigationLazyView(button.1())) {
                        Text(button.0)
                            .font(.title)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                    }
                    Divider()
                }
            }
        }
        .if(user.name != nil) {
            $0.navigationBarTitle(user.name!)
        }
    }
    
    private func coordinateToCoordinate2D(coordinate: Geo?) -> Coordinate2D {
        let latitude = Double(coordinate?.lat ?? "0") ?? 0
        let longitude = Double(coordinate?.lng ?? "0") ?? 0
        return Coordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        return UserDetailsView(user: testUser)
    }
}
