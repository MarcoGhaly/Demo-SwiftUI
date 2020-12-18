//
//  DefaultLCEListView.swift
//  Demo
//
//  Created by Marco Ghaly on 17/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct DefaultLCEListView<Element, ViewModel, ID, CellContent>: View where ViewModel: LCEListViewModel<Element>, ID: Hashable, CellContent: View {
    @ObservedObject var viewModel: ViewModel
    let id: KeyPath<Element, ID>
    let isEditMode: Bool
    @Binding var selectedIndices: Set<ID>
    let cellContent: (Element) -> CellContent
    let loadingView: AnyView? = nil
    
    init(viewModel: ViewModel, id: KeyPath<Element, ID>, isEditMode: Bool = false, selectedIndices: Binding<Set<ID>> = .constant([]), cellContent: @escaping (Element) -> CellContent) {
        self.viewModel = viewModel
        self.id = id
        self.isEditMode = isEditMode
        self._selectedIndices = selectedIndices
        self.cellContent = cellContent
    }
    
    var body: some View {
        LCEListView(viewModel: viewModel, id: id, isEditMode: isEditMode, selectedIndices: _selectedIndices) { model in
            cellContent(model)
        } loading: { loadingViewModel in
            DefaultLoadingView(loadingViewModel: loadingViewModel)
        } error: { errorViewModel in
            DefaultErrorView(errorViewModel: errorViewModel)
        } paginationLoading: {
            ActivityIndicator(isAnimating: .constant(true), style: .large)
        }
    }
}

extension DefaultLCEListView where Element: Identifiable, ID == Element.ID {
    init(viewModel: ViewModel, isEditMode: Bool = false, selectedIndices: Binding<Set<ID>> = .constant([]), cellContent: @escaping (Element) -> CellContent) {
        self.init(viewModel: viewModel, id: \Element.id, isEditMode: isEditMode, selectedIndices: selectedIndices, cellContent: cellContent)
    }
}

struct DefaultLCEListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LCEListViewModel<String>()
        viewModel.model = ["Hello", "World"]
        
        return DefaultLCEListView(viewModel: viewModel, id: \.self) { element in
            Text(element)
        }
    }
}
