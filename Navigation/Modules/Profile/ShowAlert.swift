

import Foundation
import UIKit

struct ShowAlert {
    
    func showAlert(vc: UIViewController, title: String, message: String, titleButton: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: .default)
        alert.addAction(action)
        
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.present(alert, animated: true)
    }
}
