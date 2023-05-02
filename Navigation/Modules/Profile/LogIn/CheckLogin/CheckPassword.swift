//
//  CheckPassword.swift
//  Navigation
//
//  Created by Андрей Банин on 20.2.23..
//

import Foundation

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}
