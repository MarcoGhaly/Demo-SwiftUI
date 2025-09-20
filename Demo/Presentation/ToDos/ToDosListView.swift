import SwiftUI

struct ToDosListView<ViewModel>: View where ViewModel: ToDosViewModel<ToDosUseCases> {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        BaseLCEListView(viewModel: viewModel, showEditButtons: viewModel.userID != nil) { toDo in
            ToDoItemView(toDo: toDo)
        }
        .navigationBarTitle("ToDos")
    }
}

#Preview {
    let viewModel = ToDosViewModel(useCases: ToDosUseCases())
    viewModel.model = [TestData.testToDo]
    viewModel.viewState = .content
    return ToDosListView(viewModel: viewModel)
}
