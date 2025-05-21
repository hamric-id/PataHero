//
//  Route_ViewModel.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 15/05/25.
//

import MapKit

class Route_Map_ViewModel: ObservableObject {
    @Published var route: MKRoute?

    func calculateRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                DispatchQueue.main.async {
                    self.route = route
                }
            }
        }
    }
}
