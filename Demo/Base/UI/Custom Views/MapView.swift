//
//  MapView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI
import MapKit

struct Coordinate2D {
    let latitude: Double
    let longitude: Double
    
    var mapCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapView: UIViewRepresentable {
    // MARK:- Constants
    
    private static let annotationIdentifier = "ISSAnnotation"
    
    // MARK:- Variables
    
    private let mapViewDelegate = MapViewDelegate()
    
    var coordinate: Coordinate2D?
    var delta: Double?
    var annotations: [Coordinate2D]?
    var pinImage: UIImage?
    var trajectory: [Coordinate2D]?
    
    // MARK:- Initialization
    
    init(coordinate: Coordinate2D? = nil, delta: Double? = nil, annotations: [Coordinate2D]? = nil, pinImage: UIImage? = nil, trajectory: [Coordinate2D]? = nil) {
        self.coordinate = coordinate
        self.delta = delta
        self.annotations = annotations
        self.pinImage = pinImage
        self.trajectory = trajectory
        mapViewDelegate.parent = self
    }
    
    // MARK:- View Creation
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.delegate = mapViewDelegate

        if let coordinate = self.coordinate {
            setRegion(mapView: mapView, coordinate: coordinate, delta: self.delta)
        }
        
        if let annotations = self.annotations {
            addAnnotations(mapView: mapView, coordinates: annotations)
        }
        
        if let trajectory = self.trajectory {
            addPolyline(mapView: mapView, trajectory: trajectory)
        }
    }
    
    // MARK:- Custom Methods
    
    private func setRegion(mapView: MKMapView, coordinate: Coordinate2D, delta: Double?) {
        let coordinate = coordinate.mapCoordinate
        if let delta = delta {
            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
        } else {
            mapView.centerCoordinate = coordinate
        }
    }
    
    private func addAnnotations(mapView: MKMapView, coordinates: [Coordinate2D]) {
        mapView.removeAnnotations(mapView.annotations)
        for coordinate in coordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate.mapCoordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    private func addPolyline(mapView: MKMapView, trajectory: [Coordinate2D]) {
        mapView.removeOverlays(mapView.overlays)
        let trajectory = trajectory.map { $0.mapCoordinate }
        let polyline = MKPolyline(coordinates: trajectory, count: trajectory.count)
        mapView.addOverlay(polyline)
    }
    
    // MARK:- Map View Delegate
    
    private class MapViewDelegate: NSObject, MKMapViewDelegate {
        var parent: MapView?
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MapView.annotationIdentifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: MapView.annotationIdentifier)
                annotationView?.image = parent?.pinImage
            }
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .black
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: Coordinate2D(latitude: 30.0444, longitude: 31.2357), pinImage: UIImage(named: "satellite"))
    }
}
