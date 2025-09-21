import SwiftUI

struct TabsView: View {
    private let spacing: CGFloat = 20

    var body: some View {
        TabView {
            tabView(title: "Users", iconName: "person.fill") {
                UsersListView(viewModel: UsersViewModel())
            }
            tabView(title: "Posts", iconName: "envelope.fill") {
                PostsListView(viewModel: PostsViewModel())
            }
            tabView(title: "Comments", iconName: "message.fill") {
                CommentsListView(viewModel: CommentsViewModel())
            }
            tabView(title: "ToDos", iconName: "checkmark.circle.fill") {
                ToDosListView(viewModel: ToDosViewModel())
            }
            tabView(title: "Albums", iconName: "photo.fill") {
                AlbumsListView(viewModel: AlbumsViewModel())
            }
        }
    }
}

private extension TabsView {
    func tabView<Destination>(
        title: String,
        iconName: String,
        destination: @escaping () -> Destination
    ) -> some View where Destination: View {
        NavigationView {
            NavigationLazyView(destination)
        }
        .tabItem {
            Image(systemName: iconName)
            Text(title)
        }
    }
}

#Preview {
    TabsView()
}
