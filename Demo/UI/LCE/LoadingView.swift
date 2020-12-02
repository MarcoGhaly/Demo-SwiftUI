//
//  LoadingView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/8/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    var text = "Loading..."
    var padding: CGFloat = 25
    var spacing: CGFloat = 25
    
    var body: some View {
        VStack(spacing: spacing) {
            ActivityIndicator(isAnimating: .constant(true), style: .large)
            
            Text(text)
                .font(.body)
        }
        .padding(padding)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .previewLayout(.fixed(width: 400, height: 200))
    }
}
