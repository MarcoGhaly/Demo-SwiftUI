import SwiftUI

struct ToDosListView<ViewModel>: View where ViewModel: ToDosViewModel<ToDosUseCases> {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        BaseLCEListView(viewModel: viewModel, showEditButtons: viewModel.userID != nil) { toDo in
            ToDoRowView(toDo: toDo)
        }
        .navigationBarTitle("ToDos")
    }
}

struct ToDosListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ToDosViewModel(useCases: ToDosUseCases())
        viewModel.model = [testToDo]
        viewModel.viewState = .content
        return ToDosListView(viewModel: viewModel)
    }
}
