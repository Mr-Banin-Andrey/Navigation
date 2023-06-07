
import Foundation
import RealmSwift

protocol RealmServiceProtocol: AnyObject {
    func createUser(user: LogInUser) -> Bool
    func fetch() -> Bool //[LogInUser]
}

final class RealmService {
    
    
}

extension RealmService: RealmServiceProtocol {
    
    
    
    func createUser(user: LogInUser) -> Bool {
        do {
            
            let realm = try Realm()
            
            try realm.write {
                realm.create(
                    UserRealmModel.self,
                    value: user.keyedValues
                )
                
            }
            return true
        } catch {
            return false
        }
    }
    
    func fetch() -> Bool {
        do {
            let realm = try Realm()
            
            let objects = realm.objects(UserRealmModel.self)
            
            
            let user = objects.where {
                $0.login == "pec" || $0.password == "123"
//                print($0)
                
            }
            return true
            
//            guard let userRealmModel = Array(objects) as? [UserRealmModel] else {
//                return []
//            }
//
//            return userRealmModel.map { LogInUser(userRealmModel: $0) }
        } catch {
            return false
        }
    }
}
