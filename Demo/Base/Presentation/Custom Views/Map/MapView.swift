import SwiftUI
import MapKit

struct MapView<Annotation: AnnotationProtocol>: View {
    private static var defaultCoordinate: Coordinate2D { .zero }
    private static var defaultDelta: Double { 0.001 }
    
    @State var coordinate: Coordinate2D
    @State var delta: Double
    @State var annotations: [Annotation]
    
    private var coordinateRegion: Binding<MKCoordinateRegion> {
        Binding {
            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            return MKCoordinateRegion(center: coordinate.mapCoordinate, span: span)
        } set: { _ in
        }
    }
    
    init(coordinate: Coordinate2D = defaultCoordinate, delta: Double = defaultDelta, annotations: [Annotation]) {
        self._coordinate = State(initialValue: coordinate)
        self._delta = State(initialValue: delta)
        self._annotations = State(initialValue: annotations)
    }
    
    init(coordinate: Coordinate2D = defaultCoordinate, delta: Double = defaultDelta, annotations: [Coordinate2D] = []) where Annotation == DefaultAnnotation {
        let annotations = annotations.map {
            DefaultAnnotation(coordinate: $0)
        }
        self.init(coordinate: coordinate, delta: delta, annotations: annotations)
    }
    
    var body: some View {
        Map(coordinateRegion: coordinateRegion, annotationItems: annotations) { annotation in
            MapPin(coordinate: annotation.coordinate.mapCoordinate)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let coordinate = Coordinate2D(latitude: 30.0444, longitude: 31.2357)
        MapView(coordinate: coordinate)
    }
}

extension Coordinate2D {
    var mapCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
