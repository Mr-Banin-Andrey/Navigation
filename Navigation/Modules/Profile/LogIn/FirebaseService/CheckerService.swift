

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
        vc: UIViewController,
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    )
    func checkCredentials(
        withEmail email: String,
        password: String,
        vc: UIViewController,
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    )
    func singOut() throws
}


class CheckerService {
    
    private func responseHendler(
        _ response: (authData: AuthDataResult?, error: Error?),
        vc: UIViewController,
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    ) {
        let useDispachQueue: (Result<UserModel, CheckerError>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        if let error = response.error {
            if error.localizedDescription == "The password is invalid or the user does not have a password." {
                let showAlert = ShowAlert()
                showAlert.showAlert(
                    vc: vc,
                    title: NSLocalizedString("universalMeaning.alert.title", comment: ""),
                    message: NSLocalizedString("firebase.checkerService.alert.accountExists.message", comment: ""),
                    titleButton: NSLocalizedString("universalMeaning.Button.tryAgain", comment: "")
                )
            } else if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                let showAlert = ShowAlert()
                showAlert.showAlert(
                    vc: vc,
                    title: NSLocalizedString("universalMeaning.alert.title", comment: ""),
                    message: NSLocalizedString("firebase.checkerService.alert.accountDoesNotExist.message", comment: ""),
                    titleButton: NSLocalizedString("universalMeaning.Button.tryAgain", comment: "")
                )
            }
            
            useDispachQueue(.failure(.unknownError(reason: error.localizedDescription)))
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
    
    private func emptyPasswordOrEmailField(
        vc: UIViewController,
        email: String,
        password: String,
        title: String,
        message: String
    ) -> Bool {
        if email.isEmpty || password.isEmpty {
            let showAlert = ShowAlert()
            showAlert.showAlert(
                vc: vc,
                title: NSLocalizedString("universalMeaning.alert.title", comment: ""),
                message: NSLocalizedString("firebase.checkerService.alert.cellEmpty.message", comment: ""),
                titleButton: NSLocalizedString("universalMeaning.Button.tryAgain", comment: "")
            )
            return true
        }
        return false
    }
    
}

extension CheckerService: CheckerServiceProtocol {
    
    func singUp(
        withEmail email: String,
        password: String,
        vc: UIViewController,
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    ) {
        let isEmpty = emptyPasswordOrEmailField(
            vc: vc,
            email: email,
            password: password,
            title: NSLocalizedString("universalMeaning.alert.title", comment: ""),
            message: NSLocalizedString("firebase.checkerService.alert.cellEmpty.message", comment: "")
        )
        
        if isEmpty == false {
            Auth.auth().createUser(
                withEmail: email,
                password: password
            ) { [weak self] (authData, error) in
                self?.responseHendler(
                    (authData: authData, error: error),
                    vc: vc,
                    completion: completion
                )
            }
        }
    }
    
    func checkCredentials(
        withEmail email: String,
        password: String,
        vc: UIViewController,
        completion: @escaping (Result<UserModel, CheckerError>) -> Void
    ) {
        let isEmpty = emptyPasswordOrEmailField(
            vc: vc,
            email: email,
            password: password,
            title: NSLocalizedString("universalMeaning.alert.title", comment: ""),
            message: NSLocalizedString("firebase.checkerService.alert.cellEmpty.message", comment: "")
        )
        
        if isEmpty == false {
            Auth.auth().signIn(
                withEmail: email,
                password: password
            ) { [weak self] (authData, error) in
                self?.responseHendler(
                    (authData: authData, error: error),
                    vc: vc,
                    completion: completion
                )
            }
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
