//
//  LCEListView.swift
//  Demo
//
//  Created by Marco Ghaly on 25/11/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct LCEListView<Element, ViewModel, ID, CellContent, Destination, Loading, Error, PaginationLoading>: View where ViewModel: LCEListViewModel<Element>, ID: Hashable, CellContent: View, Destination: View, Loading: LoadingView, Error: ErrorView, PaginationLoading: View {
    @ObservedObject var viewModel: ViewModel
    let columns: Int
    let spacing: CGFloat
    let id: KeyPath<Element, ID>
    let isEditMode: Bool
    @Binding var selectedIDs: Set<ID>
    let cellContent: (Element) -> CellContent
    let destination: (Element) -> Destination
    let loading: (LoadingViewModel) -> Loading
    let error: (ErrorViewModel) -> Error
    let paginationLoading: () -> PaginationLoading
    
    @State private var selectedDestination: Destination?
    @State private var navigate = false
    
    init(viewModel: ViewModel, columns: Int = 1, spacing: CGFloat = 15, id: KeyPath<Element, ID>, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder cellContent: @escaping (Element) -> CellContent, @ViewBuilder destination: @escaping (Element) -> Destination, loading: @escaping (LoadingViewModel) -> Loading, error: @escaping (ErrorViewModel) -> Error, paginationLoading: @escaping () -> PaginationLoading) {
        self.viewModel = viewModel
        self.columns = columns
        self.spacing = spacing
        self.id = id
        self.isEditMode = isEditMode
        self._selectedIDs = selectedIDs
        self.cellContent = cellContent
        self.destination = destination
        self.loading = loading
        self.error = error
        self.paginationLoading = paginationLoading
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
        cellContent(element)
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
        GeometryReader { bottomGeometry in
            let _ = DispatchQueue.main.async {
                let offset = bottomGeometry.frame(in: .global).minY - outerGeometry.frame(in: .global).maxY
                if offset <= 0 {
                    viewModel.scrolledToEnd()
                }
            }
            Color.clear
        }
        .frame(height: 0)
    }
}

extension LCEListView where Element: Identifiable, ID == Element.ID {
    init(viewModel: ViewModel, columns: Int = 1, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder cellContent: @escaping (Element) -> CellContent, @ViewBuilder destination: @escaping (Element) -> Destination, loading: @escaping (LoadingViewModel) -> Loading, error: @escaping (ErrorViewModel) -> Error, paginationLoading: @escaping () -> PaginationLoading) {
        self.init(viewModel: viewModel, columns: columns, id: \Element.id, isEditMode: isEditMode, selectedIDs: selectedIDs, cellContent: cellContent, destination: destination, loading: loading, error: error, paginationLoading: paginationLoading)
    }
}

struct LCEListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LCEListViewModel<String>()
        viewModel.model = ["Hello", "World"]
        
        return LCEListView(viewModel: viewModel, id: \.self) { element in
            Text(element)
        } destination: { _ in
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
        .previewLayout(.sizeThatFits)
    }
}
