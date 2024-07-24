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

struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CommentsViewModel(useCases: CommentsUseCases(), postID: testPost.id)
        viewModel.model = [testComment]
        viewModel.viewState = .content
        return CommentsListView(viewModel: viewModel)
    }
}
