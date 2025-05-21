//
//  Location_Manager.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 14/05/25.
//

#if os(watchOS)
import WatchKit
#else
import UIKit
#endif

import CoreLocation
import Combine

class Location_Manager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocation? = CLLocation(latitude: -6.302186726542358, longitude: 106.6521901546525) //simulasi lokasi the breeze

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        #if !os(watchOS)
        locationManager.requestWhenInUseAuthorization()
        #endif

        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
}

//import CoreLocation
//
//class Location_Manager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var currentLocation: CLLocation?// = CLLocation(latitude: -6.302186726542358, longitude: 106.6521901546525) //simulasi lokasi the breeze
//
//    private let locationManager = CLLocationManager()
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = kCLDistanceFilterNone // or a value like 5.0 (meters)
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = locations.last
//    }
//}
