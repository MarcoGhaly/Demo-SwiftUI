//
//  LoadingView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/8/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

enum LoadingViewStyle: CaseIterable {
    case normal
    case dialog
}

struct LoadingView: View {
    private let padding: CGFloat = 25
    private let spacing: CGFloat = 25
    private let background = Color.black.opacity(0.3)
    
    var style = LoadingViewStyle.normal
    var text = "Loading..."
    
    var body: some View {
        VStack(spacing: spacing) {
            ActivityIndicator(isAnimating: .constant(true), style: .large)
            Text(text)
                .font(.body)
        }
        .padding(padding)
        .if(style == .dialog) {
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
            LoadingView(style: styles[index])
                .previewLayout(.fixed(width: 400, height: 300))
        }
    }
}
