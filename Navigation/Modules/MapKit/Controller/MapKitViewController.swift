

import Foundation
import UIKit

class MapKitViewController: UIViewController {
    
    var coordinator: MapKitCoordinator?
    
    private lazy var mapKitView: MapKitView = MapKitView(delegate: self)
    
    
    override func loadView() {
        super.loadView()
        
        view = mapKitView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MapKitViewController: MapKitViewDelegate {
    
}
