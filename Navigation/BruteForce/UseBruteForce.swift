
import Foundation

struct UseBruteForce {
    func bruteForce(passwordToUnlock: String) -> String {
        
        let bruteForce = BruteForce()
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        var password: String = ""

        while password != passwordToUnlock {
            password = bruteForce.generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
        }
        
        print(password)

        return password
    }
    
    func randomPassword() -> String {
        var randomSymbolArray: [Character] = []
        
        countSymbol: while randomSymbolArray.count != 4 {
            switch randomSymbolArray.count {
            case 0,1,2,3:
                let symbol = (String().letters + String().digits).randomElement()
                randomSymbolArray.append(symbol ?? "-")
                continue countSymbol
            default:
                break countSymbol
            }
        }
        
        let randomSymbol = String(randomSymbolArray)
        print("\(randomSymbol) - randomSymbol")
        return randomSymbol
    }
}
