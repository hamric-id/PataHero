//
//  Map_View.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 19/05/25.
//

import SwiftUI
import MapKit
#if os(watchOS)
import WatchKit
#endif

//struct Route_Map_View: View {
//    @StateObject private var location_Manager = Location_Manager()
//    
//    private let destination_Location: CLLocationCoordinate2D
//    #if !os(watchOS)
//    @StateObject private var route_Map_ViewModel = Route_Map_ViewModel()
//    #endif
//    
//    init(_ destination_Location: CLLocationCoordinate2D){
//        self.destination_Location=destination_Location
//    }
//
//    
//
//    var body: some View {
//        VStack {
//            if let current_Location = location_Manager.currentLocation?.coordinate {
//                #if os(watchOS)
//                Route_Map_View_WatchKit(currentLocation: current_Location, destination: destination_Location)
//                    .edgesIgnoringSafeArea(.all)
//                #else
//                Route_Map_View_withUIKit(
//                    route: route_Map_ViewModel.route,
//                    userLocation: current_Location,
//                    destination: destination_Location
//                )
//                .onAppear {route_Map_ViewModel.calculateRoute(from: current_Location, to: destination_Location)}
//                .onChange(of: location_Manager.currentLocation) { newLoc in
//                    if let loc = newLoc {route_Map_ViewModel.calculateRoute(from: loc.coordinate, to: destination_Location)}
//                }
//                .edgesIgnoringSafeArea(.all)
//                #endif
//            } else {
//                Text("Fetching location...")
//            }
//        }
//    }
//}

struct OpenAppleMapsView: View {
    @StateObject var locationManager = Location_Manager()
    
    // Set your destination
    let destination = CLLocationCoordinate2D(latitude: -6.2986459, longitude: 106.6707105) // Example: Eka Hospital BSD

    var body: some View {
        VStack {
            if let current = locationManager.currentLocation {
                Text("Current Location:")
                Text("\(current.coordinate.latitude), \(current.coordinate.longitude)")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                
                Button("Open in Apple Maps") {
                    openInMaps(destination: destination)
                }
                .padding()
            } else {
                Text("Fetching location...")
            }
        }
    }

    func openInMaps(destination: CLLocationCoordinate2D) {
        let destinationString = "\(destination.latitude),\(destination.longitude)"
        if let url = URL(string: "http://maps.apple.com/?daddr=\(destinationString)&dirflg=d") {
            WKExtension.shared().openSystemURL(url)
        }
    }
}

//class Route_Map_ViewModel: ObservableObject {
//    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
//
//    func calculateRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
//        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
//        request.transportType = .automobile
//
//        let directions = MKDirections(request: request)
//        directions.calculate { response, error in
//            guard let polyline = response?.routes.first?.polyline else { return }
//
//            // Extract coordinates from polyline
//            var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: polyline.pointCount)
//            polyline.getCoordinates(&coords, range: NSRange(location: 0, length: polyline.pointCount))
//
//            DispatchQueue.main.async {
//                // Optional: downsample to reduce annotations (e.g., every 5th point)
//                self.routeCoordinates = coords.enumerated().compactMap { index, coord in
//                    index % 5 == 0 ? coord : nil
//                }
//            }
//        }
//    }
//}

//struct Route_Map_View_WatchKit: WKInterfaceObjectRepresentable {
//    var currentLocation: CLLocationCoordinate2D
//    var destination: CLLocationCoordinate2D
//
//    func makeWKInterfaceObject(context: Context) -> WKInterfaceMap {
//        let map = WKInterfaceMap()
//        return map
//    }
//
//    func updateWKInterfaceObject(_ map: WKInterfaceMap, context: Context) {
//        // Clear and re-add annotations
//        map.removeAllAnnotations()
//        
//        map.addAnnotation(destination, with: .red)
//        map.addAnnotation(currentLocation, with: .green)
//
//        let centerLat = (currentLocation.latitude + destination.latitude) / 2
//        let centerLon = (currentLocation.longitude + destination.longitude) / 2
//
//        let region = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
//            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        )
//
//        map.setRegion(region)
//    }
//}

#Preview {
    OpenAppleMapsView()//Route_Map_View(EkaHospital_Location)
}	
