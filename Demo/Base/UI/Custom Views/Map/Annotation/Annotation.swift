//
//  Annotation.swift
//  Demo
//
//  Created by Marco Ghaly on 23/01/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import Foundation
import SwiftUI

struct Annotation<Content: View>: AnnotationProtocol {
    var coordinate: Coordinate2D
    var content: Content
    
    init(coordinate: Coordinate2D, @ViewBuilder content: () -> Content) {
        self.coordinate = coordinate
        self.content = content()
    }
}
