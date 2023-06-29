

import Foundation
import UIKit
import CoreLocation
import MapKit

class MapKitViewController: UIViewController {
    
    var coordinator: MapKitCoordinator?
    
    private lazy var mapKitView: MapKitView = MapKitView(delegate: self)
    
    private let mapView = MKMapView()
    
    private lazy var locationManager: LocationManagerSettings = LocationManagerSettings.shared
    
    override func loadView() {
        super.loadView()

        view = mapKitView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapKitView.navigationController(navigation: navigationItem, leftButton: mapKitView.leftButton, title: "Map")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.configureMapView(delegate: self)
    }

}

extension MapKitViewController: MapKitViewDelegate { }

extension MapKitViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first?.coordinate else { return }
        self.mapView.setCenter(userLocation, animated: true)
    }
    
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

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: ", error)
    }
}


