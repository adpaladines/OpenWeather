//
//  CurrentWeatherData.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

struct CurrentWeatherData: Decodable {
    let coord: CoordinateData
    let weather: [WeatherData]
    let base: String
    let main: MainWeatherPart
    let visibility: Int
    let wind: Wind?
    let rain: Rain?
    let snow: Snow?
    let clouds: Clouds?
    let dt: Int
    let sys: Sys?
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct CoordinateData: Decodable {
    let lat: Double
    let lon: Double
}

struct WeatherData: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainWeatherPart: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct Wind: Decodable {
    let speed: Double
    let deg: Double
}

struct Rain: Decodable {
    
    let the1H: Double?
    let the3H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

struct Snow: Decodable {
    let the1H: Double?
    let the3H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

struct Clouds: Decodable {
    let all: Int
}

struct Sys: Decodable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
