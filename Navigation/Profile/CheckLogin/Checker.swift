//
//  Checker.swift
//  Navigation
//
//  Created by Андрей Банин on 17.2.23..
//

import Foundation
import UIKit

class Checker {
        
    static let shared = Checker()
    
    private init() {
        loginUser = "1"
        passwordUser = "1"
    }
    
    private let loginUser: String
    private let passwordUser: String
        
    func isCheck(_ sender: LogInViewController, login: String, password: String) -> Bool {
        
        print("checker work?")
        
        if (login == loginUser) && (password == passwordUser) {
            return true
        }
        return false
    }
}
