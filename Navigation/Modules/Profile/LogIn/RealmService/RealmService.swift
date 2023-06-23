
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
        print("🍐 0 key - ", key)
        _ = key.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
        }
        print("🍐 1 key - ", key)
        print("🍐 2 key.description.utf8 - ", key.description.utf8)
        UserDefaultsKeyRealm().tokenEncoder(data: key)
        return key
        
    }
    
    

    
}

extension RealmService: RealmServiceProtocol {
    
    func createUser(user: LogInUser) -> Bool {
        
        let key = UserDefaultsKeyRealm().tokenDecoder()
        var varibleKey: Data = Data()
        
        if key.isEmpty {
            varibleKey = createKey()
        } else {
            varibleKey = key
        }

        let config = Realm.Configuration(encryptionKey: varibleKey)
        
        do {
            
            let realm = try Realm(configuration: config)
            
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
        } catch let error {
            print("❌ Error -", error)
            return false
        }
    }
    
    func fetch() -> [LogInUser] {
        
        let key = UserDefaultsKeyRealm().tokenDecoder()
        
        let config = Realm.Configuration(encryptionKey: key)

        do {
            
            let realm = try Realm(configuration: config)
            
            let objects = realm.objects(UserRealmModel.self)
            
            guard let userRealmModel = Array(objects) as? [UserRealmModel] else {
                return []
            }
            return userRealmModel.map { LogInUser(userRealmModel: $0) }
        } catch let error{
            print("❌ Error -", error)
            return []
        }
    }
    
    func removeUser(user: LogInUser) -> Bool {
        
        let key = UserDefaultsKeyRealm().tokenDecoder()
        
        let config = Realm.Configuration(encryptionKey: key)

        do {
            
            let realm = try Realm(configuration: config)
            
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
