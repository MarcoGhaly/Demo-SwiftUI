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
    let cellContent: (Element) -> CellContent
    let loadingView: AnyView? = nil
    
    var body: some View {
        LCEListView(viewModel: viewModel, id: id) { model in
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
    init(viewModel: ViewModel, cellContent: @escaping (Element) -> CellContent) {
        self.init(viewModel: viewModel, id: \Element.id, cellContent: cellContent)
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
