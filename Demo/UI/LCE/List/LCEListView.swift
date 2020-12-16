//
//  LCEListView.swift
//  Demo
//
//  Created by Marco Ghaly on 25/11/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct LCEListView<CellContent, ViewModel, Element, ID>: View where CellContent: View, ViewModel: LCEListViewModel<Element>, ID: Hashable {
    @ObservedObject var viewModel: ViewModel
    let cellContent: (Element) -> CellContent
    let id: KeyPath<Element, ID>
    let loadingView: AnyView? = nil
    
    var body: some View {
        DefaultLCEView(viewModel: viewModel) { model in
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
        }
    }
}

extension LCEListView where Element: Identifiable, ID == Element.ID {
    init(viewModel: ViewModel, cellContent: @escaping (Element) -> CellContent, loadingView: AnyView? = nil) {
        self.init(viewModel: viewModel, cellContent: cellContent, id: \Element.id)
    }
}

struct LCEListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LCEListViewModel<String>()
        viewModel.model = ["Hello", "World"]
        return LCEListView(viewModel: viewModel, cellContent: { element in
            Text(element)
        }, id: \.self)
        .previewLayout(.sizeThatFits)
    }
}
