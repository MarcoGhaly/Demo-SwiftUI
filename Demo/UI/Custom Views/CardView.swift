//
//  CardView.swift
//  Demo
//
//  Created by Marco Ghaly on 11/12/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import SwiftUI

struct CardView: ViewModifier {
    var backgroundColor: Color
    var cornerRadius: CGFloat
    var shadowColor: Color
    var shadowCornerRadius: CGFloat
    var shadowOffset: CGPoint
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor, radius: shadowCornerRadius, x: shadowOffset.x, y: shadowOffset.y)
    }
}

extension View {
    func cardify(backgroundColor: Color = .white, cornerRadius: CGFloat = 10, shadowColor: Color = .gray, shadowCornerRadius: CGFloat = 10, shadowOffset: CGPoint = .zero) -> some View {
        modifier(CardView(backgroundColor: backgroundColor, cornerRadius: cornerRadius, shadowColor: shadowColor, shadowCornerRadius: shadowCornerRadius, shadowOffset: shadowOffset))
    }
}
