//
//  ContentWrappingGeometryReader.swift
//  Demo
//
//  Created by Marco Ghaly on 01/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

private struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ContentWrappingGeometryReader<Content>: View where Content: View {
    let content: (CGSize) -> Content
    @State private var size: CGSize = SizeKey.defaultValue
    
    var body: some View {
        content(size)
            .background(GeometryReader { geometry in
                Color.clear.preference(key: SizeKey.self, value: geometry.size)
            })
            .onPreferenceChange(SizeKey.self, perform: { value in
                size = value
            })
    }
}

struct ContentWrappingGeometryReader_Previews: PreviewProvider {
    static var previews: some View {
        ContentWrappingGeometryReader { size in
            Text("Hello World")
                .foregroundColor(.white)
                .background(Color.black)
        }
        .previewLayout(.fixed(width: 400, height: 100))
    }
}