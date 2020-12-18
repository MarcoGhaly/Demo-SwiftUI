//
//  LCEListView.swift
//  Demo
//
//  Created by Marco Ghaly on 25/11/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct LCEListView<Element, ViewModel, ID, CellContent, Loading, Error, PaginationLoading>: View where ViewModel: LCEListViewModel<Element>, ID: Hashable, CellContent: View, Loading: LoadingView, Error: ErrorView, PaginationLoading: View {
    @ObservedObject var viewModel: ViewModel
    let id: KeyPath<Element, ID>
    let isEditMode: Bool
    @Binding var selectedIndices: Set<ID>
    let cellContent: (Element) -> CellContent
    let loading: (LoadingViewModel) -> Loading
    let error: (ErrorViewModel) -> Error
    let paginationLoading: () -> PaginationLoading
    
    init(viewModel: ViewModel, id: KeyPath<Element, ID>, isEditMode: Bool = false, selectedIndices: Binding<Set<ID>> = .constant([]), cellContent: @escaping (Element) -> CellContent, loading: @escaping (LoadingViewModel) -> Loading, error: @escaping (ErrorViewModel) -> Error, paginationLoading: @escaping () -> PaginationLoading) {
        self.viewModel = viewModel
        self.id = id
        self.isEditMode = isEditMode
        self._selectedIndices = selectedIndices
        self.cellContent = cellContent
        self.loading = loading
        self.error = error
        self.paginationLoading = paginationLoading
    }
    
    var body: some View {
        LCEView(viewModel: viewModel) { model in
            GeometryReader { outerGeometry in
                ScrollView {
                    LazyVStack {
                        ForEach(model, id: id) { element in
                            cellContent(element)
                                .if(isEditMode) {
                                    $0.simultaneousGesture(TapGesture().onEnded({ value in
                                        let identifier = element[keyPath: id]
                                        if selectedIndices.remove(identifier) == nil {
                                            selectedIndices.insert(identifier)
                                        }
                                    }))
                                }
                        }
                        
                        if viewModel.isLoading {
                            paginationLoading()
                                .frame(maxWidth: .infinity)
                        }
                        
                        if !isEditMode {
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
                }
            }
        } loading: { loadingViewModel in
            loading(loadingViewModel)
        } error: { errorViewModel in
            error(errorViewModel)
        }
    }
}

extension LCEListView where Element: Identifiable, ID == Element.ID {
    init(viewModel: ViewModel, isEditMode: Bool = false, selectedIndices: Binding<Set<ID>> = .constant([]), cellContent: @escaping (Element) -> CellContent, loading: @escaping (LoadingViewModel) -> Loading, error: @escaping (ErrorViewModel) -> Error, paginationLoading: @escaping () -> PaginationLoading) {
        self.init(viewModel: viewModel, id: \Element.id, isEditMode: isEditMode, selectedIndices: selectedIndices, cellContent: cellContent, loading: loading, error: error, paginationLoading: paginationLoading)
    }
}

struct LCEListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LCEListViewModel<String>()
        viewModel.model = ["Hello", "World"]
        
        return LCEListView(viewModel: viewModel, id: \.self) { element in
            Text(element)
        } loading: { loadingViewModel in
            DefaultLoadingView(loadingViewModel: loadingViewModel)
        } error: { errorViewModel in
            DefaultErrorView(errorViewModel: errorViewModel)
        } paginationLoading: {
            ActivityIndicator(isAnimating: .constant(true), style: .large)
        }
        .previewLayout(.sizeThatFits)
    }
}
