//
//  DefaultAnnotation.swift
//  Demo
//
//  Created by Marco Ghaly on 23/01/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import Foundation
import SwiftUI

struct DefaultAnnotation: AnnotationProtocol {
    var coordinate: Coordinate2D
    
    var content: some View {
        Image(systemName: "mappin")
            .font(.largeTitle)
            .foregroundColor(.red)
    }
}
