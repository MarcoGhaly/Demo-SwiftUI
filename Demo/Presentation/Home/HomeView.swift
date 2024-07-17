import SwiftUI

struct HomeView: View {
    private let spacing: CGFloat = 20

    var body: some View {
        TabView {
            ForEach(buttonModels, id: \.self.title) { buttonModel in
                NavigationView {
                    NavigationLazyView(buttonModel.destinationView())
                }
                .tabItem {
                    Image(systemName: buttonModel.iconName)
                    Text(buttonModel.title)
                }
            }
        }
    }
}

private extension HomeView {
    // Put views in closures to allow lazy navigation
    var buttonModels: [ButtonModel] {
        [
            .init(title: "Users", iconName: "person.fill") {
                UsersListView(viewModel: UsersViewModel()).toAnyView()
            },
            .init(title: "Posts", iconName: "envelope.fill") {
                PostsListView(viewModel: PostsViewModel()).toAnyView()
            },
            .init(title: "Comments", iconName: "message.fill") {
                CommentsListView(viewModel: CommentsViewModel()).toAnyView()
            },
            .init(title: "ToDos", iconName: "checkmark.circle.fill") {
                ToDosListView(viewModel: ToDosViewModel()).toAnyView()
            },
            .init(title: "Albums", iconName: "photo.fill") {
                AlbumsListView(viewModel: AlbumsViewModel()).toAnyView()
            }
        ]
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
