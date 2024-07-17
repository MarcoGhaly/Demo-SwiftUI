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
