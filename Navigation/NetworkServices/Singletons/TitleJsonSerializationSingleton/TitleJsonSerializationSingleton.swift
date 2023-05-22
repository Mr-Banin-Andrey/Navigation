

import Foundation

class TitleJsonSerialization {
    
    static let shared = TitleJsonSerialization()
    
    private init() {
        urlJson = "https://jsonplaceholder.typicode.com/todos/1"
    }
    
    private let urlJson: String
    
    func loadJson(completion: @escaping (String) -> Void)  {

        if let url = URL(string: urlJson) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let unrappedData = data {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: unrappedData)
                        print(dictionary)
                        
                        if let dict = dictionary as? [String: Any], let title = dict["title"] as? String {
                            completion(title)
                            print(title)
                        }
                    } catch let error {
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
