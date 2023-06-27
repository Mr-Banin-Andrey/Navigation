

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
        
        self.mapKitView.navigationController(navigation: navigationItem, title: "Map")        
    }

}

extension MapKitViewController: MapKitViewDelegate {

}


