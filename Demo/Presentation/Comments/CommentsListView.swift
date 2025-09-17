import SwiftUI

struct CommentsListView<ViewModel>: View where ViewModel: CommentsViewModel<CommentsUseCases> {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        BaseLCEListView(viewModel: viewModel, showEditButtons: viewModel.postID != nil) { comment in
            CommentRowView(comment: comment)
        }
        .if(viewModel.postID == nil) {
            $0.navigationBarTitle("Comments")
        }
    }
}

#Preview {
    let viewModel = CommentsViewModel(useCases: CommentsUseCases(), postID: TestData.testPost.id)
    viewModel.model = [TestData.testComment]
    viewModel.viewState = .content
    return CommentsListView(viewModel: viewModel)
}
