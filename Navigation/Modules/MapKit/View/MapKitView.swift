
import Foundation
import UIKit
import MapKit
import CoreLocation

protocol MapKitViewDelegate: AnyObject {
    
}

class MapKitView: UIView {
    
    private weak var delegate: MapKitViewDelegate?
    
    var locationManager = CLLocationManager()
    
    init(delegate: MapKitViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.checkUserLocationPermissions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkUserLocationPermissions() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Попросить пользователя зайти в настройки")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Пользователь разрешил использовать геолокацию")
        @unknown default:
            fatalError("Не обрабатываемый статус")
        }
    }
}
