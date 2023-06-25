
import Foundation

struct LogInUser {
    
    let login: String
    let password: String
    
    
    var keyedValues: [String: Any] {
        [
            "login": self.login,
            "password": self.password
        ]
    }
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
    
    init(userRealmModel: UserRealmModel) {
        self.login = userRealmModel.login ?? ""
        self.password = userRealmModel.password ?? ""
    }
    
}
