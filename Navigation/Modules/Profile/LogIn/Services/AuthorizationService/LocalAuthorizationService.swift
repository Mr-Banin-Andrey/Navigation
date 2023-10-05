

import Foundation
import LocalAuthentication

protocol LocalAuthorizationServiceProtocol {
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void)
}

class LocalAuthorizationService {
    
}

extension LocalAuthorizationService: LocalAuthorizationServiceProtocol {
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        let context = LAContext()
        let policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        var error: NSError? = nil
        let canEvaluate = context.canEvaluatePolicy(policy, error: &error)
        
        if let error {
            print("canEvaluate: error-", error)
        }
        
        guard canEvaluate else { return print("Запрещено использовать биометрию") }
        
        context.evaluatePolicy(
            policy,
            localizedReason: "Авторизируйтесь для входа"
        ) { success, error in
            DispatchQueue.main.async {
                authorizationFinished(success)
            }
            print("evaluatePolicy error: error-", error?.localizedDescription ?? "")
        }
    }
}
