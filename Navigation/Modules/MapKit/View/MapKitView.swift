
import Foundation
import UIKit
import MapKit
import CoreLocation

protocol MapKitViewDelegate: AnyObject {
    
}

class MapKitView: UIView {
    
    private weak var delegate: MapKitViewDelegate?
    
    private let locationManager = CLLocationManager()
    private let mapView = MKMapView()
    
    private var varibleCoordinate = CLLocationCoordinate2D()
    
    init(delegate: MapKitViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        
        self.setupMapView()
        
        self.configureMapView()
        
        self.longTapGesture()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(mapView)
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func navigationController(navigation: UINavigationItem, title: String) {
        self.backgroundColor = .systemBackground
        navigation.title = title
    }
    
    private func addPoute(destination: CLLocationCoordinate2D) {
        guard let source = locationManager.location?.coordinate else { return }
        
        self.mapView.removeOverlays(mapView.overlays)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            if let route = response.routes.first {
                self.mapView.delegate = self
                self.mapView.addOverlay(route.polyline)
            }
        }
    }
    
    private func configureMapView() {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.addPin()
        self.mapView.showsCompass = true
    }
    
    private func addPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: 42.278356, longitude: 18.838163)
        pin.title = "Old Town Budva"
        
        mapView.addAnnotation(pin)
    }
    
    private func longTapGesture() {
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(tapEdit(_:)))
        mapView.addGestureRecognizer(longTap)
    }
    
    private func showAlert(coordinators: CLLocationCoordinate2D, pin: MKAnnotation) {
        
        let shortLatitude = shortCoordinatorsToString(coordinator: coordinators.latitude)
        let shortLongitude = shortCoordinatorsToString(coordinator: coordinators.longitude)
        
        let alertController = UIAlertController(title: "\(shortLatitude)˚N, \(shortLongitude)˚E", message: nil, preferredStyle: .actionSheet)
        
        
        let addPin = UIAlertAction(title: "Отметить точку", style: .default) { _ in

        }
        
        let createRoute = UIAlertAction(title: "Посторить маршрут", style: .default) { _ in
            self.addPoute(destination: coordinators)
        }
        
        let cancelAction = UIAlertAction(title: "Удалить отметку", style: .cancel) { _ in
            for annotationX in self.mapView.annotations {
                if annotationX.title == "\(shortLatitude)˚N, \(shortLongitude)˚E" {
                    self.mapView.removeAnnotation(annotationX)
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(createRoute)
        alertController.addAction(addPin)
        
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.present(alertController, animated: true)
    }
    
    private func shortCoordinatorsToString(coordinator: CLLocationDegrees) -> String {
        
        let word = coordinator.description
        
        if word.count <= 9 {
            return word
        } else {
            let countRemove = word.count - 9
            let result = word.dropLast(countRemove).string
            return result
        }
    }
    
    @objc private func tapEdit(_ longGesture: UIGestureRecognizer) {
        let touchPoint = longGesture.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let shortLatitude = shortCoordinatorsToString(coordinator: newCoordinates.latitude)
        let shortLongitude = shortCoordinatorsToString(coordinator: newCoordinates.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        annotation.title = "\(shortLatitude)˚N, \(shortLongitude)˚E"
        mapView.addAnnotation(annotation)
        
        
        showAlert(coordinators: newCoordinates, pin: annotation)
    }
    
}

extension MapKitView: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {

        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            print("У пользователя спросили разрешения использовать геолокацию")

        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
            print("Пользователь разрешил использовать геолокацию")

        case .denied, .restricted:
            print("Попросить пользователя зайти в настройки")
        @unknown default:
            fatalError("Не обрабатываемый статус")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.first?.coordinate else { return }
        
        self.mapView.setCenter(userLocation, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MapKitView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .cyan
        renderer.lineWidth = 2.5
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let shortLatitude = shortCoordinatorsToString(coordinator: annotation.coordinate.latitude)
        let shortLongitude = shortCoordinatorsToString(coordinator: annotation.coordinate.longitude)
        var viewMarker: MKMarkerAnnotationView
        let idView = "marker"

        let refreshAction = UIAction(title: "Remove") { (action) in
            
            for annotationX in self.mapView.annotations {
                if annotationX.title == "\(shortLatitude)˚N, \(shortLongitude)˚E" {
                    self.mapView.removeAnnotation(annotationX)
                }
            }
        }

        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: idView) as? MKMarkerAnnotationView{
            view.annotation = annotation
            viewMarker = view
        } else {
            viewMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: idView)
            viewMarker.canShowCallout = true
            viewMarker.calloutOffset = CGPoint(x: 0, y: 8)
            viewMarker.rightCalloutAccessoryView = UIButton(type: .close, primaryAction: refreshAction)
        }


        return viewMarker
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        guard let annotation = view.annotation else { return }
        
        let shortLatitude = shortCoordinatorsToString(coordinator: annotation.coordinate.latitude)
        let shortLongitude = shortCoordinatorsToString(coordinator: annotation.coordinate.longitude)
        
        for annotationX in self.mapView.annotations {
            if annotationX.title == "\(shortLatitude)˚N, \(shortLongitude)˚E" {
                self.mapView.removeAnnotation(annotationX)
            }
        }
        
        
        if self.mapView.overlays.isEmpty == false {
            let request = MKDirections.Request()
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
        }
    }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
