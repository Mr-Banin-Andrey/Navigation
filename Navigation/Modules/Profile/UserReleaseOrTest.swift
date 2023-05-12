//
//  User.swift
//  Navigation
//
//  Created by Андрей Банин on 23.3.23..
//

import Foundation

class UserReleaseOrTest {
    let login: String
    let fullName: String
    let status: String
    let userPhoto: String
    
    init(login: String, fullName: String, status: String, userPhoto: String) {
        self.login = login
        self.fullName = fullName
        self.status = status
        self.userPhoto = userPhoto
    }
}
