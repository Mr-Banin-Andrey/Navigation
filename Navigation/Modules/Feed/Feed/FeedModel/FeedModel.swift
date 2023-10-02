

import Foundation

struct Value {
    let text: String
    let color: String
}

enum CheckError: Error {
    case wrong(value: Value)
    case emptyValue(value: Value)
}


protocol FeedModelProtocol {
    func isCheck(word: String, completion: @escaping ((Result<Value, CheckError>) -> Void))
}

final class FeedModel: FeedModelProtocol {
    
    private let secretWord: String = "word"
    private let emptyValue: String = ""
    
    private let arrayValue: [Value] = [
        Value(text: " \("feedModel.isCheckResult.true".localized) ", color: "green"),
        Value(text: "  \("feedModel.isCheckResult.false".localized) ", color: "red")
    ]
        
    public func isCheck(word: String, completion: @escaping ((Result<Value, CheckError>) -> Void)) {
        if secretWord == word {
            completion(.success(arrayValue[0]))
        } else if emptyValue == word {
            completion(.failure(.emptyValue(value: arrayValue[1])))
        } else {
            completion(.failure(.wrong(value: arrayValue[1])))
        }
    }
}
