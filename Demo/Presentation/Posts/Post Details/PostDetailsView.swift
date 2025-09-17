import SwiftUI

struct PostDetailsView: View {
    @ObservedObject var viewModel: PostViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            viewModel.post.title.map {
                Text($0).font(.headline)
            }
            
            viewModel.post.body.map {
                Text($0).font(.body)
            }
            
            Divider()
            
            Text("Comments:").font(.title)
            
            CommentsListView(viewModel: CommentsViewModel(postID: viewModel.post.id))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
        .navigationBarTitle(viewModel.post.title ?? "")
    }
}

#Preview {
    let viewModel = PostViewModel(post: TestData.testPost)
    PostDetailsView(viewModel: viewModel)
}
