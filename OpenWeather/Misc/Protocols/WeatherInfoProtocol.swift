//
//  WeatherInfoProtocol.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import CoreLocation

protocol WeatherInfoProtocol {
//    func getCurrentWeatherInfoCombine(coordinate: CLLocationCoordinate2D)
//    func getDailyForecastInfoCombine(coordinate: CLLocationCoordinate2D)
//    func getAirPollutionDataCombine(coordinate: CLLocationCoordinate2D)
    
    func fetchServerData(coordinate: CLLocationCoordinate2D)
}
