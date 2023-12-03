//
//  UrlEndpoints.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

enum ApiVersion: String {
    case version_2_5 = "/data/2.5/"
    case version_3_0 = "/data/3/"
    case test = ""
}

struct UrlEndpoints {
    static let shared: UrlEndpoints = .init()
    
    var apiKey: String {
        UserDefaults.standard.string(forKey: "api_key_selected") ?? ""
    }
    
    private init() {}
    
    var baseWeatherApi: String {
        "https://api.openweathermap.org"
    }
    
    var baseWeather: String {
        "https://openweathermap.org"
    }
    
    var images: String {
        "/img/wn/"
    }
    
    var api2_5: String {
        "/data/2.5/"
    }

    var currentWeather: String {
        "weather"
    }
    
    var forecast: String {
        "forecast"
    }
    
    var airPollution: String {
        "air_pollution"
    }

}
