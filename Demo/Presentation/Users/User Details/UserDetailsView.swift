import SwiftUI

struct UserDetailsView: View {
    let user: User

    var body: some View {
        let coordinate = coordinateToCoordinate2D(coordinate: user.address?.geo)
        
        VStack(spacing: 0) {
            MapView(coordinate: coordinate, delta: 0.005, annotations: [coordinate])
            UserItemView(user: user)
            Divider()
            buttonsView
        }
        .navigationBarTitle(user.name ?? "")
    }
    
    private var buttonsView: some View {
        HStack(spacing: 0) {
            navigationView(title: "Posts", iconName: "envelope.fill") {
                PostsListView(viewModel: PostsViewModel(userID: user.id))
            }
            Divider().frame(maxHeight: 100)
            navigationView(title: "ToDos", iconName: "checkmark.circle.fill") {
                ToDosListView(viewModel: ToDosViewModel(userID: user.id))
            }
            Divider().frame(maxHeight: 100)
            navigationView(title: "Albums", iconName: "photo.fill") {
                AlbumsListView(viewModel: AlbumsViewModel(userID: user.id))
            }
        }
    }
}

private extension UserDetailsView {
    func navigationView<Destination>(
        title: String,
        iconName: String,
        destination: @escaping () -> Destination
    ) -> some View where Destination: View {
        NavigationLink(
            destination: NavigationLazyView(destination)
        ) {
            VStack(spacing: 10) {
                Image(systemName: iconName)
                    .font(.largeTitle)
                
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
        }
    }

    func coordinateToCoordinate2D(coordinate: Geo?) -> Coordinate2D {
        let latitude = Double(coordinate?.lat ?? "0") ?? 0
        let longitude = Double(coordinate?.lng ?? "0") ?? 0
        return Coordinate2D(latitude: latitude, longitude: longitude)
    }
}

#Preview {
    UserDetailsView(user: TestData.testUser)
}
