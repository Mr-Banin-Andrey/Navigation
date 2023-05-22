

import Foundation

class Checker {
        
    static let shared = Checker()
    
    private init() {
        loginUser = ReleaseOrTest().user.login
        passwordUser = "1"
    }
    
    private let loginUser: String
    private let passwordUser: String
        
    func isCheck(_ sender: LogInViewController, login: String, password: String) -> Bool {
        if (login == loginUser) && (password == passwordUser) {
            return true
        }
        return false
    }
}
