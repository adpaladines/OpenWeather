//
//  Units.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

//Enum to create a partof URL request about measurement type
enum MeasurementUnit: String, CaseIterable {
    case standard
    case metric
    case imperial
    
    func getUnit() -> String {
        let value: String
        switch self {
        case .standard:
            value = "Kelvin"
        case .metric:
            value = "Celcius"
        case .imperial:
            value = "Fahrenheit"
        }
        return value
    }
    
    var urlParameter: String {
        let value: String
        switch self {
        case .standard:
            value = "standard"
        case .metric:
            value = "metric"
        case .imperial:
            value = "imperial"
        }
        return value
    }
}
