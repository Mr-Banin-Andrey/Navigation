
import Foundation
import UIKit
import MapKit

protocol MapKitViewDelegate: AnyObject {
    
}

class MapKitView: UIView {
    
    private weak var delegate: MapKitViewDelegate?
    
    private let mapView = MKMapView()
        
    private var varibleRoute = MKMapItem()
    
    lazy var leftButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                            target: self,
                                                            action: #selector(deletePins))
    
    private lazy var locationManager: LocationManagerSettings = LocationManagerSettings.shared
    
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
    
    func navigationController(navigation: UINavigationItem, leftButton: UIBarButtonItem, title: String) {
        self.backgroundColor = .systemBackground
        
        leftButton.tintColor = UIColor(named: "blueColor")
        
        navigation.title = title
        navigation.leftBarButtonItems = [leftButton]
        navigation.leftBarButtonItem = leftButton
    }
    
    private func addRoute(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        
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
                varibleRoute = response.destination
            }
        }
    }
    
    private func configureMapView() {
        self.mapView.showsUserLocation = true
        self.addPin()
        self.mapView.showsCompass = true
        self.mapView.showsScale = true
        self.mapView.showsUserLocation = true
        self.mapView.mapType = .hybridFlyover
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
        
        let shortLatitude = locationManager.shortCoordinatorsToString(coordinator: coordinators.latitude)
        let shortLongitude = locationManager.shortCoordinatorsToString(coordinator: coordinators.longitude)
        
        let alertController = UIAlertController(title: "\(shortLatitude)˚N, \(shortLongitude)˚E", message: nil, preferredStyle: .actionSheet)
        
        let addPin = UIAlertAction(title: "Отметить точку", style: .default)
        
        let createRoute = UIAlertAction(title: "Посторить маршрут", style: .default) { _ in
            guard let source = self.locationManager.giveUserLocation() else { return }
            self.addRoute(source: source, destination: coordinators)
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
    
    @objc private func deletePins() {
        self.mapView.removeAnnotations(mapView.annotations)
        self.addPin()
        self.mapView.removeOverlays(mapView.overlays)
    }
    
    @objc private func tapEdit(_ longGesture: UIGestureRecognizer) {
        let touchPoint = longGesture.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let shortLatitude = locationManager.shortCoordinatorsToString(coordinator: newCoordinates.latitude)
        let shortLongitude = locationManager.shortCoordinatorsToString(coordinator: newCoordinates.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        annotation.title = "\(shortLatitude)˚N, \(shortLongitude)˚E"
        mapView.addAnnotation(annotation)
        
        showAlert(coordinators: newCoordinates, pin: annotation)
    }
    
}


extension MapKitView: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .cyan
        renderer.lineWidth = 2.5
        return renderer
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        guard let coordinator = view.annotation?.coordinate else { return }

        for annotation in self.mapView.annotations {

            if annotation.coordinate.latitude == coordinator.latitude && annotation.coordinate.longitude == coordinator.longitude {

                self.mapView.removeAnnotation(annotation)

                let routeCoordinate = varibleRoute.placemark.coordinate
                let annotationCoordinate = annotation.coordinate

                if routeCoordinate.latitude == annotationCoordinate.latitude && routeCoordinate.longitude == annotationCoordinate.longitude {
                    self.mapView.removeOverlays(mapView.overlays)
                }
            }
        }
    }
}
