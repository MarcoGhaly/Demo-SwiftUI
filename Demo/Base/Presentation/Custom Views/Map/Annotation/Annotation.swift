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
