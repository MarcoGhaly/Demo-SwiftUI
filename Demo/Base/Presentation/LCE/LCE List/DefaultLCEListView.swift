import SwiftUI

struct DefaultLCEListView<Element, AppError, ViewModel, ID, ItemContent, Destination>: View
where ViewModel: LCEListViewModel<Element, AppError>, ID: Hashable, ItemContent: View, Destination: View {
    @ObservedObject var viewModel: ViewModel
    let columns: Int
    let id: KeyPath<Element, ID>
    let isEditMode: Bool
    @Binding var selectedIDs: Set<ID>
    let itemContent: (Element) -> ItemContent
    let destination: (Element) -> Destination
    
    init(
        viewModel: ViewModel,
        columns: Int = 1,
        id: KeyPath<Element, ID>,
        isEditMode: Bool = false,
        selectedIDs: Binding<Set<ID>> = .constant([]),
        @ViewBuilder itemContent: @escaping (Element) -> ItemContent,
        @ViewBuilder destination: @escaping (Element) -> Destination
    ) {
        self.viewModel = viewModel
        self.columns = columns
        self.id = id
        self.isEditMode = isEditMode
        self._selectedIDs = selectedIDs
        self.itemContent = itemContent
        self.destination = destination
    }
    
    init(
        viewModel: ViewModel,
        columns: Int = 1,
        id: KeyPath<Element, ID>,
        isEditMode: Bool = false,
        selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder
        itemContent: @escaping (Element) -> ItemContent
    ) where Destination == EmptyView {
        self.init(
            viewModel: viewModel,
            columns: columns,
            id: id,
            isEditMode: isEditMode,
            selectedIDs: selectedIDs,
            itemContent: itemContent,
            destination: { _ in EmptyView() }
        )
    }
    
    var body: some View {
        LCEListView(
            viewModel: viewModel,
            columns: columns,
            id: id,
            isEditMode: isEditMode,
            selectedIDs: _selectedIDs,
            itemContent: { model in
                itemContent(model)
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
            }
        )
    }
}

extension DefaultLCEListView where Element: Identifiable, ID == Element.ID {
    init(
        viewModel: ViewModel,
        columns: Int = 1,
        isEditMode: Bool = false,
        selectedIDs: Binding<Set<ID>> = .constant([]),
        @ViewBuilder itemContent: @escaping (Element) -> ItemContent,
        @ViewBuilder destination: @escaping (Element) -> Destination
    ) {
        self.init(
            viewModel: viewModel,
            columns: columns,
            id: \Element.id,
            isEditMode: isEditMode,
            selectedIDs: selectedIDs,
            itemContent: itemContent,
            destination: destination
        )
    }
    
    init(
        viewModel: ViewModel,
        columns: Int = 1,
        isEditMode: Bool = false,
        selectedIDs: Binding<Set<ID>> = .constant([]),
        @ViewBuilder itemContent: @escaping (Element) -> ItemContent
    ) where Destination == EmptyView {
        self.init(
            viewModel: viewModel,
            columns: columns,
            isEditMode: isEditMode,
            selectedIDs: selectedIDs,
            itemContent: itemContent,
            destination: { _ in EmptyView() }
        )
    }
}

#Preview {
    let viewModel = LCEListViewModel<String, Error>(models: ["Hello", "World"])
    DefaultLCEListView(viewModel: viewModel, id: \.self) { element in
        Text(element)
    }
}
