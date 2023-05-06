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
            if let url = URL(string: "https://swapi.dev/api/films/1/") {
                
                var request = URLRequest(url: url)
                request.addValue("filmsURL", forHTTPHeaderField: "0")
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                    print("1. String(data: data!, encoding: .utf8)!", String(data: data!, encoding: .utf8)!)
//                    let httpResponse = HTTPURLResponse()
//                    print("2. httpResponse.allHeaderFields", httpResponse.allHeaderFields)
//                    print("3. httpResponse.statusCode", httpResponse.statusCode)
//                    print("4. response!", response!)
                }
                task.resume()
            }
        case .speciesURL:
            if let url = URL(string: "https://swapi.dev/api/species/2/") {
                
                var request = URLRequest(url: url)
                request.addValue("speciesURL", forHTTPHeaderField: "abs")
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    print("1. String(data: data!, encoding: .utf8)!", String(data: data!, encoding: .utf8)!)
                    let httpResponse = HTTPURLResponse()
                    print("2. httpResponse.allHeaderFields", httpResponse.allHeaderFields)
                    print("3. httpResponse.statusCode", httpResponse.statusCode)
                    //                    print("4. response!", response!)
                                    }
                                    task.resume()
                                }
                            case .vehiclesURL:
                                if let url = URL(string: "https://swapi.dev/api/vehicles/4/") {
                                    
                                    var request = URLRequest(url: url)
                request.addValue("vehiclesURL", forHTTPHeaderField: "abs")
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    print("1. String(data: data!, encoding: .utf8)!", String(data: data!, encoding: .utf8)!)
                    let httpResponse = HTTPURLResponse()
                    print("2. httpResponse.allHeaderFields", httpResponse.allHeaderFields)
                    print("3. httpResponse.statusCode", httpResponse.statusCode)
//                    print("4. response!", response!)
                }
                task.resume()
            }
        }
        
    }
}
