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
    var content: () -> Content
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            case .error(let title, let message):
                ErrorView(title: title, message: message)
            case .content:
                content()
            }
        }
    }
    
}

struct LCEView_Previews: PreviewProvider {
    static var previews: some View {
        let states: [LCEViewModel<Any>.State] = [.loading, .error(title: "Error Title", message: "Error Message"), .content]
        return ForEach(states.indices) { index in
            getLCEView(state: states[index])
        }
        .previewLayout(.fixed(width: 400, height: 150))
    }

    private static func getLCEView(state: LCEViewModel<Any>.State) -> LCEView<Text, LCEViewModel<Any>, Any> {
        let viewModel = LCEViewModel<Any>(model: [])
        viewModel.state = state
        return LCEView(viewModel: viewModel) {
            Text("Content")
                .font(.largeTitle)
        }
    }
}
