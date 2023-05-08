//
//  JsonModel.swift
//  Navigation
//
//  Created by Андрей Банин on 7.5.23..
//

import Foundation

struct Planet: Decodable {
    let name: String
    let rotation_period: String
    let orbital_period: String
}
