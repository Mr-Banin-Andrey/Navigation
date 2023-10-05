

import Foundation
import FirebaseAuth

struct UserModel {
    let name: String
//    let credential: CredentialModel
    
    init(from firUser: User) { // init(from firUser: User, credential: CredentialModel) {
        self.name = firUser.displayName ?? ""
        //self.credential = credential
    }
    
    init(from name: String) {
        self.name = name
    }
    
}

//struct CredentialModel {
//    let provider: String
//
//    init(from firCredential: AuthCredential) {
//        self.provider = firCredential.provider
//    }
//}
