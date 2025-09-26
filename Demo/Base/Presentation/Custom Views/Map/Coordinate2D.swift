import Foundation

struct Coordinate2D {
    let latitude: Double
    let longitude: Double
}

extension Coordinate2D {
    static let zero = Coordinate2D(latitude: 0, longitude: 0)
}
