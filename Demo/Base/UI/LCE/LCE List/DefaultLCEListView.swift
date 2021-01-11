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
    let columns: Int
    let id: KeyPath<Element, ID>
    let isEditMode: Bool
    @Binding var selectedIDs: Set<ID>
    let cellContent: (Element) -> CellContent
    let loadingView: AnyView? = nil
    
    init(viewModel: ViewModel, columns: Int = 1, id: KeyPath<Element, ID>, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), cellContent: @escaping (Element) -> CellContent) {
        self.viewModel = viewModel
        self.columns = columns
        self.id = id
        self.isEditMode = isEditMode
        self._selectedIDs = selectedIDs
        self.cellContent = cellContent
    }
    
    var body: some View {
        LCEListView(viewModel: viewModel, columns: columns, id: id, isEditMode: isEditMode, selectedIDs: _selectedIDs) { model in
            cellContent(model)
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
}

extension DefaultLCEListView where Element: Identifiable, ID == Element.ID {
    init(viewModel: ViewModel, columns: Int = 1, isEditMode: Bool = false, selectedIDs: Binding<Set<ID>> = .constant([]), cellContent: @escaping (Element) -> CellContent) {
        self.init(viewModel: viewModel, columns: columns, id: \Element.id, isEditMode: isEditMode, selectedIDs: selectedIDs, cellContent: cellContent)
    }
}

struct DefaultLCEListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LCEListViewModel<String>(models: ["Hello", "World"])
        return DefaultLCEListView(viewModel: viewModel, id: \.self) { element in
            Text(element)
        }
    }
}
