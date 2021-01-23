//
//  AnnotationProtocol.swift
//  Demo
//
//  Created by Marco Ghaly on 23/01/2021.
//  Copyright © 2021 Marco Ghaly. All rights reserved.
//

import Foundation
import SwiftUI

protocol AnnotationProtocol: Identifiable {
    associatedtype Content: View
    
    var coordinate: Coordinate2D { get }
    
    @ViewBuilder var content: Content { get }
}

extension AnnotationProtocol {
    var id: UUID { UUID() }
}
