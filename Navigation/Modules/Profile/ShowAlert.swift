//
//  ShowAlert.swift
//  Navigation
//
//  Created by Андрей Банин on 26.4.23..
//

import Foundation
import UIKit

class ShowAlert {
    
    func showAlert(vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ок", style: .default)
        alert.addAction(action)
        
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController?.present(alert, animated: true)
    }
}
