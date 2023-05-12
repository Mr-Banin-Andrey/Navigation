//
//  FirebaseAuthentication.swift
//  Navigation
//
//  Created by Андрей Банин on 12.5.23..
//

import Foundation
import FirebaseAuth

enum CheckerError: Error {
    case notAuthorized
    case custom(reason: String)
}


protocol CheckerServiceProtocol: AnyObject {
    func singUp()
    func singIn(withEmail email: String, password: String)
    func singOut() throws
}


class CheckerService {
    
}

extension CheckerService: CheckerServiceProtocol {
    
    func singUp() {
        
    }
    
    func singIn(withEmail email: String, password: String, completion: @escaping (Result<User, CheckerError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            if let error {
                completion(.failure(.custom(reason: error.localizedDescription)))
                return
            }
            
            guard
                let firUser = authData?.user,
                let firCredential = authData?.credential
            else {
                completion(.failure(.notAuthorized))
                return
            }
            
            let credential = CredentialModel(from: firCredential)
            let user = UserModel(from: firUser, credential: credential)
        }
    }
    
    func singOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw CheckerError.custom(reason: error.localizedDescription)
        }
        
    }
}
