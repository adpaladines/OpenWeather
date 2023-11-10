//
//  Repositoryable.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import CoreLocation
import Combine

protocol Repositoryable {
    var serviceManager: Serviceable { get }
    
    func setServiceManager(_ serviceManager: Serviceable, and coordinate: CLLocationCoordinate2D)
    func getCurrentWeather(metrics: MeasurementUnit?, testingPath: String) async throws -> CurrentWeatherData?
//    func getUrlForCurrentWeatherIn(city name: String, stateCode: String?, countryCode: String?, metrics: MeasurementUnit?)
    func getUrlStringImageBy(id: String) -> String?
    func getForecastData(metrics: MeasurementUnit?, testingPath: String) async throws -> ForecastData?
    func getAirPollutionData(testingPath: String) async throws -> AirPollutionData?
    
    func getCurrentWeatherCombine(metrics: MeasurementUnit?, testingPath: String) -> AnyPublisher<CurrentWeatherData?, Error>
}
