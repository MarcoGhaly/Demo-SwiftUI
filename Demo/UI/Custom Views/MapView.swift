//
//  MapView.swift
//  Demo
//
//  Created by Marco Ghaly on 8/30/20.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    private static let delta = 0.01
    
    var coordinate: Geo

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        setRegion(mapView: mapView)
    }
    
    private func setRegion(mapView: MKMapView) {
        let coordinate = coordinateToCoordinate2D(coordinate: self.coordinate)
        let span = MKCoordinateSpan(latitudeDelta: MapView.delta, longitudeDelta: MapView.delta)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func coordinateToCoordinate2D(coordinate: Geo) -> CLLocationCoordinate2D {
        let latitude = Double(coordinate.lat ?? "0") ?? 0
        let longitude = Double(coordinate.lng ?? "0") ?? 0
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: Geo(lat: "30.0444", lng: "31.2357"))
    }
}
