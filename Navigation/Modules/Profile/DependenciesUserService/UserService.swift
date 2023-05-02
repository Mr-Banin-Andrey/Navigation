//
//  UserService.swift
//  Navigation
//
//  Created by Андрей Банин on 13.2.23..
//

import Foundation

protocol UserService {
    func checkLogin(login: User) -> User?
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
