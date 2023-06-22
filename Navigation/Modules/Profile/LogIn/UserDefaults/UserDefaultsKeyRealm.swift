

import Foundation


struct RealmToken: Codable {
    let key: [String]
}

struct UserDefaultsKeyRealm {
    

    func tokenEncoder(arrayToken: RealmToken) {
        do {
            let data = try JSONEncoder().encode(arrayToken.key)
            UserDefaults.standard.set(data, forKey: "tokenUserDefaults")
            print("🍓 1 UserDefaults data -", data)
            print("закодирован key Realm")
        } catch let error {
            print(error)
        }
        
    }
    
    
    func tokenDecoder() -> [String] {
        print("🍓 00 раскодирован key Realm")
        if let tokenUser = UserDefaults().data(forKey: "tokenUserDefaults") {
            do {
                let arrayToken = try JSONDecoder().decode(RealmToken.self, from: tokenUser)
                print("🍓 2 раскодирован key Realm -", arrayToken.key)
                print("🍓 2/2 раскодирован key Realm -", arrayToken)
                return arrayToken.key
            } catch let error {
                print(error, "error")
            }
        }
        return []
    }
    
}
