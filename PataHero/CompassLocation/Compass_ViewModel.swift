//
//  Compass_ViewModel.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 14/05/25.
//
import CoreLocation
import CoreLocationUI



class Compass_ViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var heading: CLLocationDirection = 0
    @Published var distance: CLLocationDistance = 0
    @Published var bearing: CLLocationDegrees = 0
    
//    init(_ targetLocation: CLLocation){
//        self.targetLocation = targetLocation
//    }

    private let locationManager = CLLocationManager()
    
    private let targetLocation: CLLocation// = CLLocation(latitude: 40.748817, longitude: -73.985428) // Example: Empire State Building
    
    init(_ targetLocation: CLLocation) {
        // Create the target CLLocation
        self.targetLocation = targetLocation//CLLocation(latitude: targetLatitude, longitude: targetLongitude)
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        locationManager.requestWhenInUseAuthorization()
    }

//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.startUpdatingHeading()
//    }
    
    func bearingBetweenLocations(start: CLLocation, end: CLLocation) -> CLLocationDegrees {
        let lat1 = start.coordinate.latitude.radians
        let lon1 = start.coordinate.longitude.radians
        let lat2 = end.coordinate.latitude.radians
        let lon2 = end.coordinate.longitude.radians

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansBearing.degrees
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
        updateBearing()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            distance = currentLocation.distance(from: targetLocation)
            updateBearing()
        }
    }

    private func updateBearing() {
        if let current = locationManager.location {
            bearing = bearingBetweenLocations(start: current, end: targetLocation)
        }
    }
}
