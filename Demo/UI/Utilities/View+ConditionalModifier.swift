//
//  View+ConditionalModifier.swift
//  Demo
//
//  Created by Marco Ghaly on 11/19/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
