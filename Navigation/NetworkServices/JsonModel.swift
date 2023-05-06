//
//  JsonModel.swift
//  Navigation
//
//  Created by Андрей Банин on 5.5.23..
//

import Foundation


struct JsonModel {
//    let userId: Int
//    let id: Int
    let title: String
//    let completed: Bool
}

class Json {
        
    var perem = ""
    
    func loadJson() {
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let unrappedData = data {
                    
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: unrappedData)
                        print(dictionary)
                        
                        if let dict = dictionary as? [String: Any], let title = dict["title"] as? String {
                                DispatchQueue.main.sync {
                                    let infoVC = InfoViewController()
                                    infoVC.titleLabel.text = title
                                    self.perem = title
                                    print(title)
                                }
                        }
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        } else {
            print("Cannot create URL")
        }
    }
    
}

