

import Foundation


protocol AppCoordinator: AnyObject {
    
    var child: [AppCoordinator] { get set }
}
