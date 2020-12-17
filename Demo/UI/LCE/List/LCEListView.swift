//
//  LCEListView.swift
//  Demo
//
//  Created by Marco Ghaly on 25/11/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct LCEListView<CellContent, Loading, Error, ViewModel, Element, ID>: View where CellContent: View, Loading: LoadingView, Error: ErrorView, ViewModel: LCEListViewModel<Element>, ID: Hashable {
    @ObservedObject var viewModel: ViewModel
    let cellContent: (Element) -> CellContent
    let loading: (LoadingViewModel) -> Loading
    let error: (ErrorViewModel) -> Error
    let id: KeyPath<Element, ID>
    let loadingView: AnyView? = nil
    
    var body: some View {
        LCEView(viewModel: viewModel) { model in
            GeometryReader { outerGeometry in
                ScrollView {
                    LazyVStack {
                        ForEach(model, id: id) { element in
                            cellContent(element)
                        }
                        
                        if viewModel.isLoading {
                            (loadingView ?? AnyView(ActivityIndicator(isAnimating: .constant(true), style: .large)))
                                .frame(maxWidth: .infinity)
                        }
                        
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
        } loading: { loadingViewModel in
            loading(loadingViewModel)
        } error: { errorViewModel in
            error(errorViewModel)
        }
    }
}

extension LCEListView where Element: Identifiable, ID == Element.ID {
    init(viewModel: ViewModel, cellContent: @escaping (Element) -> CellContent, loading: @escaping (LoadingViewModel) -> Loading, error: @escaping (ErrorViewModel) -> Error) {
        self.init(viewModel: viewModel, cellContent: cellContent, loading: loading, error: error, id: \Element.id)
    }
}

struct LCEListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LCEListViewModel<String>()
        viewModel.model = ["Hello", "World"]
        
        return LCEListView(viewModel: viewModel, cellContent: { element in
            Text(element)
        }, loading: { loadingViewModel in
            DefaultLoadingView(loadingViewModel: loadingViewModel)
        }, error: { errorViewModel in
            DefaultErrorView(errorViewModel: errorViewModel)
        }, id: \.self)
        .previewLayout(.sizeThatFits)
    }
}
