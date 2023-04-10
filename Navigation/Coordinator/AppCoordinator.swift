//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Андрей Банин on 19.3.23..
//

import Foundation


protocol AppCoordinator: AnyObject {
    
    var child: [AppCoordinator] { get set }
}
