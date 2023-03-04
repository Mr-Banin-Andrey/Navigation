//
//  FeedModel.swift
//  Navigation
//
//  Created by Андрей Банин on 4.3.23..
//

import Foundation

final class FeedModel {
    
    let secretWord: String = "word"
    
    public func isCheck(word: String) -> Bool {
        switch word {
        case secretWord:
            return true
        case "":
            return false
        default:
            return false
        }
    }
}
