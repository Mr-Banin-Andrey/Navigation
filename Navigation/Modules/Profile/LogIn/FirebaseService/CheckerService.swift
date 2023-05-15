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
    func singIn(withEmail email: String, password: String, completion: @escaping (Result<UserModel, CheckerError>) -> Void)
    func singOut() throws
}


class CheckerService {
    
    private func responseHendler(
        _ response: (authDate: AuthDataResult?, error: Error?),
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    ) {
        let useDispachQueue: (Result<UserModel, CheckerError>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        if let response.error {
            useDispachQueue(.failure(.custom(reason: error.localizedDescription)))
            return
        }
        
        guard
            let firUser = response.authData?.user,
            let firCredential = response.authData?.credential
        else {
            useDispachQueue(.failure(.notAuthorized))
            return
        }
        
        let credential = CredentialModel(from: firCredential)
        let user = UserModel(from: firUser, credential: credential)
        
        useDispachQueue(.success(user))
    }
}

extension CheckerService: CheckerServiceProtocol {
    
    func singUp(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    ) {
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { [weak self] authData, error in
            self?.responseHendler(
                (authDate: authDate, error: error),
                completion: completion)
        }
    }
    
    func singIn(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authData, error in
            self?.responseHendler(
                (authDate: authDate, error: error),
                completion: completion)
//            let useDispachQueue: (Result<UserModel, CheckerError>) -> Void = { result in
//                DispatchQueue.main.async {
//                    completion(result)
//                }
//            }
//
//            if let error {
//                useDispachQueue(.failure(.custom(reason: error.localizedDescription)))
//                return
//            }
//
//            guard
//                let firUser = authData?.user,
//                let firCredential = authData?.credential
//            else {
//                useDispachQueue(.failure(.notAuthorized))
//                return
//            }
//
//            let credential = CredentialModel(from: firCredential)
//            let user = UserModel(from: firUser, credential: credential)
//
//            useDispachQueue(.success(user))
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
