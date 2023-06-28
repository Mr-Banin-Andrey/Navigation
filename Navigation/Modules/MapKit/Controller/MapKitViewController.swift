

import Foundation
import UIKit
import CoreLocation

class MapKitViewController: UIViewController {
    
    var coordinator: MapKitCoordinator?
    
    private lazy var mapKitView: MapKitView = MapKitView(delegate: self)
    
    
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
        
        // после вызова карты, запустить проверку локации
    }

}

extension MapKitViewController: MapKitViewDelegate {

}


