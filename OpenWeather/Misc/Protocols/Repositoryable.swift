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
    
    func getUrlStringImageBy(id: String) -> String?
    func setServiceManager(_ serviceManager: Serviceable, and coordinate: CLLocationCoordinate2D)
    
//    func getUrlForCurrentWeatherIn(city name: String, stateCode: String?, countryCode: String?, metrics: MeasurementUnit?)
    func getCurrentWeatherCombine(metrics: MeasurementUnit?, testingPath: String) -> AnyPublisher<CurrentWeatherData?, Error>
    func getForecastDataCombine(metrics: MeasurementUnit?, testingPath: String) -> AnyPublisher<ForecastData?, Error>
    func getAirPollutionDataCombine(testingPath: String) -> AnyPublisher<AirPollutionData?, Error>
}
