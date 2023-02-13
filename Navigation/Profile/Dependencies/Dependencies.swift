//
//  Dependencies.swift
//  Navigation
//
//  Created by Андрей Банин on 13.2.23..
//

import Foundation
import UIKit

protocol UserService {
    func checkLogin(login: User) -> User?
}

class User {
    let login: String
    let fullName: String
    let status: String
    let profilePhoto: UIImage
    
    init(login: String, fullName: String, status: String, profilePhoto: UIImage) {
        self.login = login
        self.fullName = fullName
        self.status = status
        self.profilePhoto = profilePhoto
    }
}

class CurrentUserService: UserService {
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func checkLogin(login: User) -> User? {
        if login.login == user.login {
            return login
        }
        return nil
    }
}

class TestUserService: UserService {
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func checkLogin(login: User) -> User? {
        if login.login == user.login {
            return login
        }
        return nil
    }
}
