

import Foundation

class NamesOfResidentsJsonSingleton {
    
    static let shared = NamesOfResidentsJsonSingleton()
    
    private init() {
        url = "https://swapi.dev/api/planets/1/"
    }
    
    private let url: String
    
    func loadJsonDecodablePlanet(completion: @escaping ([String]) -> Void)  {

        if let urlJson = URL(string: url) {
            let task = URLSession.shared.dataTask(with: urlJson) { data, response, error in
                if let unrappedData = data {
                    do {
                        let planet = try JSONDecoder().decode(CharacterOfPlanet.self, from: unrappedData)
                        print(planet)
                        completion(planet.residents)
                    } catch let error {
                        print(error)
                    }
                }
            }
            task.resume()
        } else {
            print("Cannot create URL")
        }
    }
    
    func loadUrlNamesOfResidents(url: [String], completion:  @escaping ([String]) -> Void) {
        
        var array: [String] = []
        
        url.forEach { value in
            if let url = URL(string: value) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let unrappedData = data {
                        do {
                            let planet = try JSONDecoder().decode(NamesOfResidents.self, from: unrappedData)
                            array.append(planet.name)
                            print(planet.name)
                            completion(array)
                        } catch let error {
                            print(error)
                        }
                    }
                }
                task.resume()
            } else {
                print("Cannot create URL")
            }
        }
    }
}
