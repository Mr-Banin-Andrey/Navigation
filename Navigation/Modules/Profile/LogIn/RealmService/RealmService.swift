
import Foundation
import RealmSwift

protocol RealmServiceProtocol: AnyObject {
    func createUser(user: LogInUser) -> Bool
    func fetch() -> [LogInUser]
    func removeUser(user: LogInUser) -> Bool
}

final class RealmService {
    
    func createKey() -> Data {
        var key = Data(count: 64)
        
        _ = key.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
        }
        print("🍐 1 key - ", key)
        return key
        
//        var config = Realm.Configuration(encryptionKey: key)
    }
    
    func keyEncoder(key: Data) -> [String] {
        
        if let encoderData = key.description.data(using: .utf8)  {
            let arrayOfHex = encoderData
                .map { String(format: "0x%02x", $0) }
            print("🍐 2 encoderData - ", encoderData)
            print("🍐 3 arrayOfHex - ", arrayOfHex)
            return arrayOfHex
        }
        return []
    }
    
    
    
}

extension RealmService: RealmServiceProtocol {
    
    func createUser(user: LogInUser) -> Bool {
        
//        var config = Realm.Configuration(encryptionKey: key)
        
        do {
            
            let realm = try Realm()
            
            let objects = realm.objects(UserRealmModel.self)
            
            guard let userRealmModel = Array(objects) as? [UserRealmModel] else {
                return false
            }
            print("🥃 userRealmModel ", userRealmModel)
            guard userRealmModel.isEmpty else { return false }

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
