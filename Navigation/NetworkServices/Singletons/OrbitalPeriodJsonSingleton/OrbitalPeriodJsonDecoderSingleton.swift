

import Foundation

class OrbitalPeriodJsonSingleton {
    
    static let shared = OrbitalPeriodJsonSingleton()
    
    private init() {
        urlJson = "https://swapi.dev/api/planets/1/"
    }
    
    private let urlJson: String
    
    
    func loadJson(completion: @escaping (String) -> Void)  {

        if let url = URL(string: urlJson) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let unrappedData = data {
                    do {
                        let planet = try JSONDecoder().decode(CharacterOfPlanet.self, from: unrappedData)
                        print(planet)
                        completion(planet.orbitalPeriod)
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
