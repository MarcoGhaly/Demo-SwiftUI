import Foundation

struct Coordinate2D {
    let latitude: Double
    let longitude: Double
}

extension Coordinate2D {
    static let zero = Self.init(latitude: .zero, longitude: .zero)
}
