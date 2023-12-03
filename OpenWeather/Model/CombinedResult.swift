//
//  CombinedResult.swift
//  OpenWeather
//
//  Created by andres paladines on 11/23/23.
//

import Foundation

struct CombinedResult {
    let weather: CurrentWeatherData?
    let forecast: ForecastData?
    let air: AirPollutionData?
}
