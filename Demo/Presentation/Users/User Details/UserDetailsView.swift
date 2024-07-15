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
            ForEach(buttonModels, id: \.self.title) { buttonModel in
                NavigationLink(destination: NavigationLazyView(buttonModel.destinationView())) {
                    VStack(spacing: 10) {
                        Image(systemName: buttonModel.iconName)
                            .font(.largeTitle)
                        
                        Text(buttonModel.title)
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
}

private extension UserDetailsView {
    // Put views in closures to allow lazy navigation
    var buttonModels: [ButtonModel] {
        [
            .init(title: "Posts", iconName: "envelope.fill") {
                PostsListView(viewModel: PostsViewModel(userID: user.id)).toAnyView()
            },
            .init(title: "ToDos", iconName: "checkmark.circle.fill") {
                ToDosListView(viewModel: ToDosViewModel(userID: user.id)).toAnyView()
            },
            .init(title: "Albums", iconName: "photo.fill") {
                AlbumsListView(viewModel: AlbumsViewModel(userID: user.id)).toAnyView()
            }
        ]
    }
    
    func coordinateToCoordinate2D(coordinate: Geo?) -> Coordinate2D {
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
