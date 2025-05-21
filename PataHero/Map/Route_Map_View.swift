//
//  Route_Map_View.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 15/05/25.
//

import SwiftUI
import MapKit
#if os(watchOS)
import WatchKit
#endif

struct Route_Map_View: View {
    @StateObject private var location_Manager = Location_Manager()
    
    private let destination_Location: CLLocationCoordinate2D
    #if !os(watchOS)
    @StateObject private var route_Map_ViewModel = Route_Map_ViewModel()
    #endif
    
    init(_ destination_Location: CLLocationCoordinate2D){
        self.destination_Location=destination_Location
    }

    

    var body: some View {
        VStack {
            if let current_Location = location_Manager.currentLocation?.coordinate {
                #if os(watchOS)
//                Route_Map_View_WatchKit(currentLocation: current_Location, destination: destination_Location)
//                    .edgesIgnoringSafeArea(.all)
                #else
                Route_Map_View_withUIKit(
                    route: route_Map_ViewModel.route,
                    userLocation: current_Location,
                    destination: destination_Location
                )
                .onAppear {route_Map_ViewModel.calculateRoute(from: current_Location, to: destination_Location)}
                .onChange(of: location_Manager.currentLocation) { newLoc in
                    if let loc = newLoc {route_Map_ViewModel.calculateRoute(from: loc.coordinate, to: destination_Location)}
                }
                .edgesIgnoringSafeArea(.all)
                #endif
            } else {
                Text("Fetching location...")
            }
        }
    }
}

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

#if !os(watchOS)
//pakai uikit karena versi swiftui butuh ios 17++
struct Route_Map_View_withUIKit: UIViewRepresentable {
    var route: MKRoute?
    var userLocation: CLLocationCoordinate2D
    var destination = CLLocationCoordinate2D(latitude: -6.298645961955201, longitude: 106.6707105897166) // Eka hospital bsd

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)

        let userPin = MKPointAnnotation()
        userPin.coordinate = userLocation
        userPin.title = "You"

        let destPin = MKPointAnnotation()
        destPin.coordinate = destination
        destPin.title = "Destination"

        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations([userPin, destPin])

        if let route = route {
            uiView.addOverlay(route.polyline)

            let region = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            uiView.setRegion(region, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {Coordinator()}

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.systemBlue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}
#endif

#Preview {
    Route_Map_View(EkaHospital_Location)
}
