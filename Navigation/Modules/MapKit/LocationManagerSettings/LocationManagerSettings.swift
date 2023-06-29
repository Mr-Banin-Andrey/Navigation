

import Foundation
import CoreLocation
import MapKit

protocol MapKitSettingsProtocol: AnyObject {
    func giveUserLocation() -> CLLocationCoordinate2D?
    func shortCoordinatorsToString(coordinator: CLLocationDegrees) -> String
}

final class LocationManagerSettings {
    
    private let locationManager: CLLocationManager
    
    static let shared = LocationManagerSettings()
    
    private init() {
        locationManager = CLLocationManager()
        
    }
    
    func configureMapView(delegate: CLLocationManagerDelegate) {
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = delegate
    }
    
}


extension LocationManagerSettings: MapKitSettingsProtocol {

    func giveUserLocation() -> CLLocationCoordinate2D? {
        locationManager.location?.coordinate
    }
    
    func shortCoordinatorsToString(coordinator: CLLocationDegrees) -> String {
        
        let word = coordinator.description
        
        if word.count <= 9 {
            return word
        } else {
            let countRemove = word.count - 9
            let result = word.dropLast(countRemove).string
            return result
        }
    }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
