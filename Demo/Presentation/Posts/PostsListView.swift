import SwiftUI

struct PostsListView<ViewModel>: View where ViewModel: PostsViewModel<PostsUseCases> {
    @ObservedObject var viewModel: ViewModel
    
    @State private var presentAddPostView = false
    
    var body: some View {
        let userID = viewModel.userID
        
        ZStack(alignment: .bottom) {
            Color.clear
            
            BaseLCEListView(viewModel: viewModel, showEditButtons: userID != nil, presentAddView: $presentAddPostView) { post in
                PostRowView(post: post)
            } destination: { post in
                PostDetailsView(viewModel: PostViewModel(post: post))
            }
            
            userID.map { userID in
                AddPostView(isPresented: $presentAddPostView, onConfirm: { post in
                    post.userId = userID
                    viewModel.add(post: post)
                    withAnimation {
                        presentAddPostView = false
                    }
                })
            }
        }
        .navigationBarTitle("Posts")
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PostsViewModel(useCases: PostsUseCases())
        viewModel.model = [TestData.testPost]
        viewModel.viewState = .content
        return PostsListView(viewModel: viewModel)
    }
}
