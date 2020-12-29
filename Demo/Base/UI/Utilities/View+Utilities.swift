//
//  View+Utilities.swift
//  Demo
//
//  Created by Marco Ghaly on 18/12/2020.
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
    
    func navigationLink<Destination: View>(destination: Destination) -> NavigationLink<Self, Destination> {
        NavigationLink(destination: destination) { self }
    }
}
