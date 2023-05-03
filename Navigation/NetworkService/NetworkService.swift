//
//  NetworkService.swift
//  Navigation
//
//  Created by Андрей Банин on 3.5.23..
//

import Foundation

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
        
        switch configuration {
        case .filmsURL:
            let films = "https://swapi.dev/api/films/1/"
            if let url = URL(string: films) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    print(String(data: data!, encoding: .utf8)!)
                }
                task.resume()
                print("abs")
            }
        case .speciesURL:
            let species = "https://swapi.dev/api/species/2/"
            if let url = URL(string: species) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    print(String(data: data!, encoding: .utf8)!)
                }
                task.resume()
            }
        case .vehiclesURL:
            let vehicles = "https://swapi.dev/api/vehicles/4/"
            if let url = URL(string: vehicles) {
                var request = URLRequest(url: url)
                request.addValue("", forHTTPHeaderField: "")
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    print(String(data: data!, encoding: .utf8)!)
                }
                task.resume()
            }
        }
        
    }
}

//case filmsURL(url: String) //= "https://swapi.dev/api/films/1/"
//case speciesURL(url: String) // = "https://swapi.dev/api/species/2/"
//case vehiclesURL(url: String)// = "https://swapi.dev/api/vehicles/4/"
//}
