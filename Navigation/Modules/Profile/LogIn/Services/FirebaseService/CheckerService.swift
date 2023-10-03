

import Foundation
import FirebaseAuth

enum CheckerError: Error {
    case noUserRecord
    case unknownError(reason: String)
}


protocol CheckerServiceProtocol: AnyObject {
    func singUp(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    )
    func checkCredentials(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    )
    func singOut() throws
}


class CheckerService {
    
    private func responseHendler(
        _ response: (authData: AuthDataResult?, error: Error?),
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    ) {
        let useDispachQueue: (Result<UserModel, CheckerError>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        if let error = response.error {
            if error.localizedDescription == "The password is invalid or the user does not have a password." {
                useDispachQueue(.failure(.unknownError(reason: error.localizedDescription)))
                return
            } else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                useDispachQueue(.failure(.unknownError(reason: error.localizedDescription)))
                return
            }
        }
        
        guard
            let firUser = response.authData?.user
        else {
            useDispachQueue(.failure(.noUserRecord))
            return
        }

        let user = UserModel(from: firUser)
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
        ) { [weak self] (authData, error) in
            self?.responseHendler(
                (authData: authData, error: error),
                completion: completion
            )
        }
    }
    
    func checkCredentials(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    ) {
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { [weak self] (authData, error) in
            self?.responseHendler(
                (authData: authData, error: error),
                completion: completion
            )
        }
    }
    
    func singOut() throws {
        do {
            try Auth.auth().signOut()
            print("try Auth.auth().signOut()")
        } catch {
            throw CheckerError.unknownError(reason: error.localizedDescription)
        }
        
    }
}
