//
//  PlanetStruct.swift
//  Navigation
//
//  Created by Андрей Банин on 8.5.23..
//

import Foundation

struct PlanetStruct: Decodable {
    let name: String
    let rotationPeriod: String
    let orbitalPeriod: String
    let diameter: String
    let climate: String
    let gravity: String
    let terrain: String
    let surfaceWater: String
    let population: String
    let residents: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter = "diameter"
        case climate = "climate"
        case gravity = "gravity"
        case terrain = "terrain"
        case surfaceWater = "surface_water"
        case population = "population"
        case residents = "residents"
    }
}


//"name": "Tatooine",
//    "rotation_period": "23",
//    "orbital_period": "304",
//    "diameter": "10465",
//    "climate": "arid",
//    "gravity": "1 standard",
//    "terrain": "desert",
//    "surface_water": "1",
//    "population": "200000",
//    "residents": [
//        "https://swapi.dev/api/people/1/",
//        "https://swapi.dev/api/people/2/",
//        "https://swapi.dev/api/people/4/",
//        "https://swapi.dev/api/people/6/",
//        "https://swapi.dev/api/people/7/",
//        "https://swapi.dev/api/people/8/",
//        "https://swapi.dev/api/people/9/",
//        "https://swapi.dev/api/people/11/",
//        "https://swapi.dev/api/people/43/",
//        "https://swapi.dev/api/people/62/"
//    ],
//    "films": [
//        "https://swapi.dev/api/films/1/",
//        "https://swapi.dev/api/films/3/",
//        "https://swapi.dev/api/films/4/",
//        "https://swapi.dev/api/films/5/",
//        "https://swapi.dev/api/films/6/"
//    ],
//    "created": "2014-12-09T13:50:49.641000Z",
//    "edited": "2014-12-20T20:58:18.411000Z",
//    "url": "https://swapi.dev/api/planets/1/"
//}
