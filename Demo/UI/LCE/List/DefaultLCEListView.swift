//
//  DefaultLCEListView.swift
//  Demo
//
//  Created by Marco Ghaly on 17/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct DefaultLCEListView<CellContent, ViewModel, Element, ID>: View where CellContent: View, ViewModel: LCEListViewModel<Element>, ID: Hashable {
    @ObservedObject var viewModel: ViewModel
    let cellContent: (Element) -> CellContent
    let id: KeyPath<Element, ID>
    let loadingView: AnyView? = nil
    
    var body: some View {
        LCEListView(viewModel: viewModel, cellContent: { model in
            cellContent(model)
        }, loading: { loadingViewModel in
            DefaultLoadingView(loadingViewModel: loadingViewModel)
        }, error: { errorViewModel in
            DefaultErrorView(errorViewModel: errorViewModel)
        }, id: id, paginationLoading: {
            ActivityIndicator(isAnimating: .constant(true), style: .large)
        })
    }
}

extension DefaultLCEListView where Element: Identifiable, ID == Element.ID {
    init(viewModel: ViewModel, cellContent: @escaping (Element) -> CellContent) {
        self.init(viewModel: viewModel, cellContent: cellContent, id: \Element.id)
    }
}

struct DefaultLCEListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LCEListViewModel<String>()
        viewModel.model = ["Hello", "World"]
        
        return DefaultLCEListView(viewModel: viewModel, cellContent: { element in
            Text(element)
        }, id: \.self)
    }
}
