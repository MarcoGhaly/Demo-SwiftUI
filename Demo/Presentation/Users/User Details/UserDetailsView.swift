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
    private var buttons: [(String, String, () -> AnyView)] {
        [("Posts", "envelope.fill", {PostsListView(viewModel: PostsViewModel(dataSource: PostsRepository(), userID: user.id)).toAnyView()}),
         ("ToDos", "checkmark.circle.fill", {ToDosListView(viewModel: ToDosViewModel(dataSource: ToDosRepository(), userID: user.id)).toAnyView()}),
         ("Albums", "photo.fill", {AlbumsListView(viewModel: AlbumsViewModel(dataSource: AlbumsRepository(), userID: user.id)).toAnyView()})]
    }
    
    var body: some View {
        let coordinate = coordinateToCoordinate2D(coordinate: user.address?.geo)
        
        VStack(spacing: 0) {
            MapView(coordinate: coordinate, delta: 0.005, annotations: [coordinate])
            
            UserRowView(user: user)
            
            Divider()
            
            buttonsView
        }
        .navigationBarTitle(user.name ?? "")
    }
    
    private var buttonsView: some View {
        HStack {
            ForEach(buttons, id: \.self.0) { button in
                NavigationLink(destination: NavigationLazyView(button.2())) {
                    VStack(spacing: 10) {
                        Image(systemName: button.1)
                            .font(.largeTitle)
                        
                        Text(button.0)
                            .font(.headline)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                }
                
                Divider()
                    .frame(maxHeight: 100)
            }
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
