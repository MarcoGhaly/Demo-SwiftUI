//
//  LCEView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/7/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct LCEView<Content, ViewModel, Model>: View where Content: View, ViewModel: LCEViewModel<Model> {
    @ObservedObject var viewModel: ViewModel
    let content: (Model) -> Content
    
    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .loading:
                LoadingView()
            case .error(let title, let message):
                ErrorView(title: title, message: message)
            case .content:
                viewModel.model.map { model in
                    content(model)
                }
            }
            
            if viewModel.loading {
                LoadingView(style: .dialog)
            }
        }
    }
}

struct LCEView_Previews: PreviewProvider {
    static var previews: some View {
        let states: [LCEViewModel<String>.ViewState] = [.loading, .error(title: "Error Title", message: "Error Message"), .content]
        return ForEach(states.indices) { index in
            getLCEView(state: states[index])
        }
        .previewLayout(.fixed(width: 400, height: 150))
    }

    private static func getLCEView(state: LCEViewModel<String>.ViewState) -> LCEView<Text, LCEViewModel<String>, String> {
        let viewModel = LCEViewModel<String>()
        viewModel.model = "Content"
        viewModel.viewState = state
        return LCEView(viewModel: viewModel) { model in
            Text(model)
                .font(.largeTitle)
        }
    }
}
