//
//
//import Foundation
//import CoreLocation
//import MapKit
//
//protocol MapKitSettingsProtocol: AnyObject {
//    
//}
//
//final class MapKitSettings {
//    
//    private let locationManager: CLLocationManager
//    private let mapView: MKMapView
//
//    private var varibleRoute = MKMapItem()
//    
//    
//    static let shared = MapKitSettings()
//    
//    private init() {
//        let locationManager = CLLocationManager()
//        let mapView = MKMapView()
//
//        var varibleRoute = MKMapItem()
//        
//        mapView.delegate = self
//    }
//    
//    func configureMapView() {
//        
//        locationManager.requestWhenInUseAuthorization()
//        
//        self.mapView.showsUserLocation = true
//        self.addPin()
//        self.mapView.showsCompass = true
//        self.mapView.showsScale = true
//        self.mapView.showsUserLocation = true
//        self.mapView.mapType = .hybridFlyover
//    }
//    
//    private func addPin() {
//        let pin = MKPointAnnotation()
//        pin.coordinate = CLLocationCoordinate2D(latitude: 42.278356, longitude: 18.838163)
//        pin.title = "Old Town Budva"
//        
//        mapView.addAnnotation(pin)
//    }
//    
//    func addRoute(destination: CLLocationCoordinate2D) {
//        guard let source = locationManager.location?.coordinate else { return }
//        
//        self.mapView.removeOverlays(mapView.overlays)
//        
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
//        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
//        
//        let directions = MKDirections(request: request)
//        
//        directions.calculate { [weak self] response, error in
//            guard let self = self else { return }
//            
//            guard let response = response else {
//                if let error = error {
//                    print("Error: \(error)")
//                }
//                return
//            }
//            
//            if let route = response.routes.first {
//                self.mapView.delegate = self
//                self.mapView.addOverlay(route.polyline)
//                varibleRoute = response.destination
//            }
//        }
//    }
//    
//    private func shortCoordinatorsToString(coordinator: CLLocationDegrees) -> String {
//        
//        let word = coordinator.description
//        
//        if word.count <= 9 {
//            return word
//        } else {
//            let countRemove = word.count - 9
//            let result = word.dropLast(countRemove).string
//            return result
//        }
//    }
//}
//
//
//extension MapKitSettings: CLLocationManagerDelegate, MapKitSettingsProtocol {
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        guard let userLocation = locations.first?.coordinate else { return }
//        self.mapView.setCenter(userLocation, animated: true)
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus {
//
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//            print("У пользователя спросили разрешения использовать геолокацию")
//
//        case .authorizedAlways, .authorizedWhenInUse:
//            manager.requestLocation()
//            print("Пользователь разрешил использовать геолокацию")
//
//        case .denied, .restricted:
//            print("Попросить пользователя зайти в настройки")
//        @unknown default:
//            fatalError("Не обрабатываемый статус")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("didFailWithError: ", error)
//    }
//}
//
//extension MapKitSettings: MKMapViewDelegate {
//    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = .cyan
//        renderer.lineWidth = 2.5
//        return renderer
//    }
//    
//    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//
//        guard let coordinator = view.annotation?.coordinate else { return }
//        
//        for annotation in self.mapView.annotations {
//            
//            if annotation.coordinate.latitude == coordinator.latitude && annotation.coordinate.longitude == coordinator.longitude {
//                
//                self.mapView.removeAnnotation(annotation)
//                                
//                let routeCoordinate = varibleRoute.placemark.coordinate
//                let annotationCoordinate = annotation.coordinate
//                               
//                if routeCoordinate.latitude == annotationCoordinate.latitude && routeCoordinate.longitude == annotationCoordinate.longitude {
//                    self.mapView.removeOverlays(mapView.overlays)
//                }
//            }
//        }
//    }
//}
//
//extension LosslessStringConvertible {
//    var string: String { .init(self) }
//}
