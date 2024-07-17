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
