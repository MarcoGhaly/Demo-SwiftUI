//
//  LoadingView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/8/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct DefaultLoadingView: LoadingView {
    private let padding: CGFloat = 25
    private let spacing: CGFloat = 15
    private let background = Color.black.opacity(0.3)
    
    var loadingViewModel: LoadingViewModel
    
    var body: some View {
        VStack(spacing: spacing) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(CGSize(width: 2, height: 2))
                .padding()
            
            loadingViewModel.title.map {
                Text($0)
                    .font(.headline)
            }
            
            loadingViewModel.message.map {
                Text($0)
                    .font(.body)
            }
        }
        .padding(padding)
        .if(loadingViewModel.style == .dialog) {
            $0.cardify()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(background)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        let styles = LoadingViewStyle.allCases
        ForEach(styles.indices) { index in
            DefaultLoadingView(loadingViewModel: LoadingViewModel(style: styles[index], title: "Loadig...", message: "Please Wait"))
                .previewLayout(.fixed(width: 400, height: 250))
        }
    }
}
