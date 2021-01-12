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
    let id: KeyPath<Element, ID>
    let isEditMode: Bool
    @Binding var selectedIDs: Set<ID>
    let cellContent: (Element) -> CellContent
    let destination: (Element) -> Destination
    let loading: (LoadingViewModel) -> Loading
    let error: (ErrorViewModel) -> Error
    let paginationLoading: () -> PaginationLoading
    
    init(viewModel: ViewModel, columns: Int = 1, id: KeyPath<Element, ID>, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), @ViewBuilder cellContent: @escaping (Element) -> CellContent, @ViewBuilder destination: @escaping (Element) -> Destination, loading: @escaping (LoadingViewModel) -> Loading, error: @escaping (ErrorViewModel) -> Error, paginationLoading: @escaping () -> PaginationLoading) {
        self.viewModel = viewModel
        self.columns = columns
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
            GeometryReader { outerGeometry in
                ScrollView {
                    VStack {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                            ForEach(model, id: id) { element in
                                cellView(forElement: element)
                            }
                        }
                        
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
        } loading: { loadingViewModel in
            loading(loadingViewModel)
        } error: { errorViewModel in
            error(errorViewModel)
        }
    }
    
    private func cellView(forElement element: Element) -> some View {
        let destination = self.destination(element)
        return cellContent(element)
            .if(!(destination is EmptyView)) {
                $0.navigationLink(destination: NavigationLazyView(destination))
            }
            .disabled(isEditMode)
            .if(isEditMode) {
                $0.simultaneousGesture(TapGesture().onEnded({ value in
                    let identifier = element[keyPath: id]
                    if selectedIDs.remove(identifier) == nil {
                        selectedIDs.insert(identifier)
                    }
                }))
            }
    }
    
    private func bottomIndicator(outerGeometry: GeometryProxy) -> some View {
        GeometryReader { bottomGeometry -> Text in
            DispatchQueue.main.async {
                let offset = bottomGeometry.frame(in: .global).minY - outerGeometry.frame(in: .global).maxY
                if offset <= 0 {
                    viewModel.scrolledToEnd()
                }
            }
            return Text("")
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
