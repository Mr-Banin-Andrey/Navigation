

import Foundation
import UIKit

final class FeedModel {
    
    struct Value {
        let text: String
        let color: UIColor
    }
    
    let secretWord: String = "word"
    let emptyValue: String = ""
    
    public let arrayValue: [Value] = [
        Value(text: " \(NSLocalizedString("feedModel.isCheckResult.true", comment: "")) ", color: UIColor.systemGreen),
        Value(text: "  \(NSLocalizedString("feedModel.isCheckResult.false", comment: "")) ", color: UIColor.systemRed)
    ]
    
    public func isCheck(word: String, completion: @escaping ((Result<[Value], Error>) -> Void)) -> Value {
        
        completion(.success(arrayValue))
        
        if secretWord == word {
            return arrayValue[0]
        } else if emptyValue == word {
            return arrayValue[1]
        }
        return arrayValue[1]
    }
}
