import SwiftUI

struct DefaultLCEListView<Element, AppError, ViewModel, ID, CellContent, Destination>: View
where ViewModel: LCEListViewModel<Element, AppError>, ID: Hashable, CellContent: View, Destination: View {
    @ObservedObject var viewModel: ViewModel
    let columns: Int
    let id: KeyPath<Element, ID>
    let isEditMode: Bool
    @Binding var selectedIDs: Set<ID>
    let cellContent: (Element) -> CellContent
    let destination: (Element) -> Destination
    
    init(viewModel: ViewModel, columns: Int = 1, id: KeyPath<Element, ID>, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder cellContent: @escaping (Element) -> CellContent, @ViewBuilder destination: @escaping (Element) -> Destination) {
        self.viewModel = viewModel
        self.columns = columns
        self.id = id
        self.isEditMode = isEditMode
        self._selectedIDs = selectedIDs
        self.cellContent = cellContent
        self.destination = destination
    }
    
    init(viewModel: ViewModel, columns: Int = 1, id: KeyPath<Element, ID>, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder cellContent: @escaping (Element) -> CellContent) where Destination == EmptyView {
        self.init(viewModel: viewModel, columns: columns, id: id, isEditMode: isEditMode, selectedIDs: selectedIDs, cellContent: cellContent, destination: { _ in EmptyView() })
    }
    
    var body: some View {
        LCEListView(viewModel: viewModel, columns: columns, id: id, isEditMode: isEditMode, selectedIDs: _selectedIDs, cellContent: { model in
            cellContent(model)
        }, destination: destination,
        loading: { loadingViewModel in
            DefaultLoadingView(loadingViewModel: loadingViewModel)
        }, error: { errorViewModel in
            DefaultErrorView(errorViewModel: errorViewModel)
        }, paginationLoading: {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(CGSize(width: 2, height: 2))
                .padding()
        })
    }
}

extension DefaultLCEListView where Element: Identifiable, ID == Element.ID {
    init(viewModel: ViewModel, columns: Int = 1, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder cellContent: @escaping (Element) -> CellContent, @ViewBuilder destination: @escaping (Element) -> Destination) {
        self.init(viewModel: viewModel, columns: columns, id: \Element.id, isEditMode: isEditMode, selectedIDs: selectedIDs, cellContent: cellContent, destination: destination)
    }
    
    init(viewModel: ViewModel, columns: Int = 1, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder cellContent: @escaping (Element) -> CellContent) where Destination == EmptyView {
        self.init(viewModel: viewModel, columns: columns, isEditMode: isEditMode, selectedIDs: selectedIDs, cellContent: cellContent, destination: { _ in EmptyView() })
    }
}

struct DefaultLCEListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LCEListViewModel<String, Error>(models: ["Hello", "World"])
        return DefaultLCEListView(viewModel: viewModel, id: \.self) { element in
            Text(element)
        }
    }
}
