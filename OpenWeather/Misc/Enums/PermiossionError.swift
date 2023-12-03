//
//  PermiossionError.swift
//  OpenWeather
//
//  Created by andres paladines on 11/27/23.
//

import Foundation

enum PermiossionError: Error {
    case denied
    case undefined
    case allowed
    case error(message: String)
}
