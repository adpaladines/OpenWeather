//
//  WeatherInfoProtocol.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import CoreLocation

protocol WeatherInfoProtocol {
    func getCurrentWeatherInfo(coordinate: CLLocationCoordinate2D) async
    func getDailyForecastInfo(coordinate: CLLocationCoordinate2D) async
    func getCurrentWeatherInfoCombine(coordinate: CLLocationCoordinate2D)
}
