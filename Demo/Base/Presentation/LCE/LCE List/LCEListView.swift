import SwiftUI

struct LCEListView<Element, AppError, ViewModel, ID, ItemContent, Destination, Loading, Error, PaginationLoading>: View
where ViewModel: LCEListViewModel<Element, AppError>, ID: Hashable, ItemContent: View, Destination: View, Loading: LoadingView, Error: ErrorView, PaginationLoading: View {
    @ObservedObject var viewModel: ViewModel
    let columns: Int
    let spacing: CGFloat
    let id: KeyPath<Element, ID>
    let isEditMode: Bool
    @Binding var selectedIDs: Set<ID>
    let itemContent: (Element) -> ItemContent
    let destination: (Element) -> Destination
    let loading: (LoadingViewModel) -> Loading
    let error: (ErrorViewModel) -> Error
    let paginationLoading: () -> PaginationLoading
    
    @State private var selectedDestination: Destination?
    @State private var navigate = false
    
    init(viewModel: ViewModel, columns: Int = 1, spacing: CGFloat = 15, id: KeyPath<Element, ID>, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder itemContent: @escaping (Element) -> ItemContent, @ViewBuilder destination: @escaping (Element) -> Destination, @ViewBuilder loading: @escaping (LoadingViewModel) -> Loading, @ViewBuilder error: @escaping (ErrorViewModel) -> Error, @ViewBuilder paginationLoading: @escaping () -> PaginationLoading) {
        self.viewModel = viewModel
        self.columns = columns
        self.spacing = spacing
        self.id = id
        self.isEditMode = isEditMode
        self._selectedIDs = selectedIDs
        self.itemContent = itemContent
        self.destination = destination
        self.loading = loading
        self.error = error
        self.paginationLoading = paginationLoading
    }
    
    init(viewModel: ViewModel, columns: Int = 1, spacing: CGFloat = 15, id: KeyPath<Element, ID>, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder itemContent: @escaping (Element) -> ItemContent, @ViewBuilder loading: @escaping (LoadingViewModel) -> Loading, @ViewBuilder error: @escaping (ErrorViewModel) -> Error, @ViewBuilder paginationLoading: @escaping () -> PaginationLoading) where Destination == EmptyView {
        self.init(viewModel: viewModel, columns: columns, spacing: spacing, id: id, isEditMode: isEditMode, selectedIDs: selectedIDs, itemContent: itemContent, destination: { _ in EmptyView() }, loading: loading, error: error, paginationLoading: paginationLoading)
    }
    
    var body: some View {
        LCEView(viewModel: viewModel) { model in
            contentView(forModel: model)
        } loading: { loadingViewModel in
            loading(loadingViewModel)
        } error: { errorViewModel in
            error(errorViewModel)
        }
    }
    
    private func contentView(forModel model: [Element]) -> some View {
        ZStack {
            selectedDestination.map {
                NavigationLink(destination: NavigationLazyView($0), isActive: $navigate) {}
            }
            
            listView(forModel: model)
        }
    }
    
    private func listView(forModel model: [Element]) -> some View {
        GeometryReader { outerGeometry in
            ScrollView {
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing, alignment: .top), count: columns), spacing: spacing) {
                        ForEach(model, id: id) { element in
                            cellView(forElement: element)
                        }
                    }
                    .padding(.horizontal, spacing)
                    
                    if viewModel.isLoading {
                        paginationLoading()
                            .frame(maxWidth: .infinity)
                    }
                    
                    if !isEditMode {
                        bottomIndicator(outerGeometry: outerGeometry)
                    }
                }
            }
        }
    }
    
    private func cellView(forElement element: Element) -> some View {
        itemContent(element)
            .simultaneousGesture(TapGesture().onEnded { _ in
                if isEditMode {
                    let identifier = element[keyPath: id]
                    if selectedIDs.remove(identifier) == nil {
                        selectedIDs.insert(identifier)
                    }
                } else {
                    let destination = self.destination(element)
                    if !(destination is EmptyView) {
                        selectedDestination = destination
                        navigate = true
                    }
                }
            })
    }
    
    private func bottomIndicator(outerGeometry: GeometryProxy) -> some View {
        GeometryReader { bottomGeometry -> Color in
            DispatchQueue.main.async {
                let offset = bottomGeometry.frame(in: .global).minY - outerGeometry.frame(in: .global).maxY
                if offset <= 0 {
                    viewModel.scrolledToEnd()
                }
            }
            return Color.clear
        }
        .frame(height: 0)
    }
}

extension LCEListView where Element: Identifiable, ID == Element.ID {
    init(viewModel: ViewModel, columns: Int = 1, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder itemContent: @escaping (Element) -> ItemContent, @ViewBuilder destination: @escaping (Element) -> Destination, loading: @escaping (LoadingViewModel) -> Loading, error: @escaping (ErrorViewModel) -> Error, paginationLoading: @escaping () -> PaginationLoading) {
        self.init(viewModel: viewModel, columns: columns, id: \Element.id, isEditMode: isEditMode, selectedIDs: selectedIDs, itemContent: itemContent, destination: destination, loading: loading, error: error, paginationLoading: paginationLoading)
    }
    
    init(viewModel: ViewModel, columns: Int = 1, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder itemContent: @escaping (Element) -> ItemContent, loading: @escaping (LoadingViewModel) -> Loading, error: @escaping (ErrorViewModel) -> Error, paginationLoading: @escaping () -> PaginationLoading) where Destination == EmptyView {
        self.init(viewModel: viewModel, columns: columns, isEditMode: isEditMode, selectedIDs: selectedIDs, itemContent: itemContent, destination: { _ in EmptyView() }, loading: loading, error: error, paginationLoading: paginationLoading)
    }
}

#Preview {
    let viewModel = LCEListViewModel<String, Error>()
    viewModel.model = ["Hello", "World"]
    return LCEListView(viewModel: viewModel, id: \.self) { element in
        Text(element)
    } loading: { loadingViewModel in
        DefaultLoadingView(loadingViewModel: loadingViewModel)
    } error: { errorViewModel in
        DefaultErrorView(errorViewModel: errorViewModel)
    } paginationLoading: {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(CGSize(width: 2, height: 2))
            .padding()
    }
}
