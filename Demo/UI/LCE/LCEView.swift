//
//  LCEView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/7/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct LCEView<Content, Loading, Error, ViewModel, Model>: View where Content: View, Loading: LoadingView, Error: ErrorView, ViewModel: LCEViewModel<Model> {
    @ObservedObject var viewModel: ViewModel
    let content: (Model) -> Content
    let loading: (LoadingViewModel) -> Loading
    let error: (ErrorViewModel) -> Error
    
    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .content:
                viewModel.model.map { model in
                    content(model)
                }
            case .loading(let loadingViewModel):
                loading(loadingViewModel)
            case .error(let errorViewModel):
                error(errorViewModel)
            }
            
            if viewModel.loading {
                DefaultLoadingView(loadingViewModel: LoadingViewModel(style: .dialog))
            }
        }
    }
}

struct LCEView_Previews: PreviewProvider {
    static var previews: some View {
        let loadingViewModel = LoadingViewModel(style: .normal,
                                                title: "Loading...",
                                                message: "Please Wait")
        
        let errorViewModel = ErrorViewModel(image: (type: .system, name: "multiply.circle", mode: .original),
                                            title: "Error!",
                                            message: "An Error Occurred",
                                            retry: (label: "Retry", action: {}))
        
        let states: [LCEViewModel<String>.ViewState] = [
            .loading(model: loadingViewModel),
            .error(model: errorViewModel),
            .content
        ]
        
        return ForEach(states.indices) { index in
            getLCEView(state: states[index])
        }
        .previewLayout(.fixed(width: 400, height: 150))
    }
    
    private static func getLCEView(state: LCEViewModel<String>.ViewState) -> LCEView<Text, DefaultLoadingView, DefaultErrorView, LCEViewModel<String>, String> {
        let viewModel = LCEViewModel<String>()
        viewModel.model = "Content"
        viewModel.viewState = state
        return LCEView(viewModel: viewModel, content: { model in
            Text(model)
                .font(.largeTitle)
        }, loading: { loadingViewModel in
            DefaultLoadingView(loadingViewModel: loadingViewModel)
        }, error: { errorViewModel in
            DefaultErrorView(errorViewModel: errorViewModel)
        })
    }
}
