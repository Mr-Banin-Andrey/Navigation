
import Foundation
import RealmSwift

final class UserRealmModel: Object {
    
    @objc dynamic var login: String?
    @objc dynamic var password: String?
    
    convenience init(user: LogInUser) {
        self.init()
        self.login = user.login
        self.password = user.password
    }
}
