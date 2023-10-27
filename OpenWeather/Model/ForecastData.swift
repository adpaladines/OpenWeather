//
//  ForecastData.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

struct ForecastData: Decodable{
    let list: [DayForecastData]
    let cod: String
    
}

struct DayForecastData: Decodable {
    let dt: Int
    let dt_txt: String
    let main: MainWeatherPart
    let weather: [WeatherData]
}

extension DayForecastData: Identifiable {
    var id: String {
        dt_txt
    }
}
