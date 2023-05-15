//
//  UserService.swift
//  Navigation
//
//  Created by Андрей Банин on 13.2.23..
//

import Foundation

protocol UserService {
    func checkLogin(login: UserReleaseOrTest) -> UserReleaseOrTest?
}


class CurrentUserService: UserService {
    
    let user: UserReleaseOrTest
    
    init(user: UserReleaseOrTest) {
        self.user = user
    }
    
    func checkLogin(login: UserReleaseOrTest) -> UserReleaseOrTest? {
        if login.login == user.login {
            return login
        }
        return nil
    }
}

class TestUserService: UserService {
    
    let user: UserReleaseOrTest
    
    init(user: UserReleaseOrTest) {
        self.user = user
    }
    
    func checkLogin(login: UserReleaseOrTest) -> UserReleaseOrTest? {
        if login.login == user.login {
            return login
        }
        return nil
    }
}
