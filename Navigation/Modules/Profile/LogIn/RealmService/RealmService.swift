
import Foundation
import RealmSwift

protocol RealmServiceProtocol: AnyObject {
    func createUser(user: LogInUser) -> Bool
    func fetch() -> [LogInUser]
    func removeUser(user: LogInUser) -> Bool
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
    
    func fetch() -> [LogInUser] {
        do {
            let realm = try Realm()
            
            let objects = realm.objects(UserRealmModel.self)
            
            guard let userRealmModel = Array(objects) as? [UserRealmModel] else {
                return []
            }
            return userRealmModel.map { LogInUser(userRealmModel: $0) }
        } catch {
            return []
        }
    }
    
    func removeUser(user: LogInUser) -> Bool {
        do {
            let realm = try Realm()
            
            let objects = realm.objects(UserRealmModel.self).filter { $0.login == user.login }
            let handler: () -> Void = {
                realm.delete(objects)
            }
            
            if realm.isInWriteTransaction {
                handler()
            } else {
                try realm.write {
                    handler()
                }
            }
            return true
        } catch let error {
            print("Error: \(error)")
            return false
        }
    }
}
