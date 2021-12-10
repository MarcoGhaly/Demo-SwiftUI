//
//  GeometryGetter.swift
//  Demo
//
//  Created by Marco Ghaly on 27/09/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import SwiftUI

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}
