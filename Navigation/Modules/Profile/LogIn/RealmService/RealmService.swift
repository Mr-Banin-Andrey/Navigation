
import Foundation
import RealmSwift
import Security

protocol RealmServiceProtocol: AnyObject {
    func createUser(user: LogInUser) -> Bool
    func fetch() -> [LogInUser]
    func removeUser(user: LogInUser) -> Bool
}

final class RealmService {
    
    func createKeyAndAddToKeychain() -> NSData {
        
        let keychainIdentifier = "keyRealm"
        guard
            let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)
        else { return NSData() }
        
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! NSData
        }
        
        guard let keyData = NSMutableData(length: 64) else { return NSData() }
        let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
        assert(result == 0, "Failed to get random bytes")
        
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData
        ]
        
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        
        return keyData
    }
}

extension RealmService: RealmServiceProtocol {
    
    func createUser(user: LogInUser) -> Bool {
        
        let config = Realm.Configuration(encryptionKey: createKeyAndAddToKeychain() as Data)
        
        do {
            let realm = try Realm(configuration: config)
            let objects = realm.objects(UserRealmModel.self)
            
            guard let userRealmModel = Array(objects) as? [UserRealmModel] else { return false }
            guard userRealmModel.isEmpty else { return false }

            try realm.write {
                realm.create(
                    UserRealmModel.self,
                    value: user.keyedValues
                )
            }
            return true
        } catch let error {
            print("Error: \(error)")
            return false
        }
    }
    
    func fetch() -> [LogInUser] {
                
        let config = Realm.Configuration(encryptionKey: createKeyAndAddToKeychain() as Data)

        do {
            let realm = try Realm(configuration: config)
            let objects = realm.objects(UserRealmModel.self)
            
            guard let userRealmModel = Array(objects) as? [UserRealmModel] else { return [] }
            return userRealmModel.map { LogInUser(userRealmModel: $0) }
        } catch let error{
            print("Error: \(error)")
            return []
        }
    }
    
    func removeUser(user: LogInUser) -> Bool {
        
        let config = Realm.Configuration(encryptionKey: createKeyAndAddToKeychain() as Data)
        
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
