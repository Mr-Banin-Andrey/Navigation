

import Foundation

struct UserDefaultsKeyRealm {
    

    func tokenEncoder(data: Data) {
        
        UserDefaults.standard.set(data, forKey: "tokenUserDefaults")
        print("🍓 1 добавлен key в Realm")
    }
    
    
    func tokenDecoder() -> Data {

        guard
            let tokenUser = UserDefaults().data(forKey: "tokenUserDefaults")  
        else { return Data() }
        
        print("🍓 2 извлечен key из Realm", tokenUser)
        
        return tokenUser
    }
    
}
