//
//  WeatherRepository.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import CoreLocation
import Combine

class WeatherRepository: Repositoryable {
    
    var lat, lon: String?
    var serviceManager: Serviceable = Services()
    
    init(lat: String? = nil, lon: String? = nil, serviceManager: Serviceable) {
        self.lat = lat
        self.lon = lon
        self.serviceManager = serviceManager
    }
    init() {}
    
    func setServiceManager(_ serviceManager: Serviceable, and coordinate: CLLocationCoordinate2D) {
        self.serviceManager = serviceManager
        self.lat = coordinate.latitude.stringValue
        self.lon = coordinate.longitude.stringValue
    }
    
    func getUrlStringImageBy(id: String) -> String? {
        let newUrl = UrlEndpoints.shared.baseWeather + UrlEndpoints.shared.images + id + "@2x.png"
        return newUrl
    }

}

extension WeatherRepository {
    
    func getCurrentWeatherCombine(metrics: MeasurementUnit? = nil, testingPath: String = "") -> AnyPublisher<CurrentWeatherData?, Error> {
        guard let lat_ = lat, let lon_ = lon else {
            print("Latitude and Longitude must be defined first")
            return Fail(error: NetworkError.request).eraseToAnyPublisher()
        }
        
        guard UrlEndpoints.shared.apiKey.isNotEmpty else {
            return Fail(error: NetworkError.request).eraseToAnyPublisher()
        }
        
        let path = testingPath.isEmpty ? UrlEndpoints.shared.currentWeather : testingPath
        var requestable = CurrentWeatherRequest(apiVersion: .version_2_5, path: path)
        requestable.set(lat: lat_, lon: lon_, metrics: metrics)
        
        return serviceManager.getDataFromApiCombine(requestable: requestable)
//            .debounce(for: .seconds(1), scheduler: DispatchQueue.global())
            .tryMap { data in
                return try JSONDecoder().decode(CurrentWeatherData.self, from: data)
            }
            .mapError { error in
                return NetworkError.parsingValue
            }
            .eraseToAnyPublisher()
    }
    
    func getForecastDataCombine(metrics: MeasurementUnit?, testingPath: String) -> AnyPublisher<ForecastData?, Error> {
        guard let lat_ = lat, let lon_ = lon else {
            print("Latitude and Longitude must be defined first")
            return Fail(error: NetworkError.request).eraseToAnyPublisher()
        }
        let path = testingPath.isEmpty ? UrlEndpoints.shared.forecast : testingPath
        var requestable = CurrentWeatherRequest(apiVersion: .version_2_5, path: path)
        requestable.set(lat: lat_, lon: lon_, metrics: metrics)
        
        return serviceManager.getDataFromApiCombine(requestable: requestable)
//            .debounce(for: .seconds(1), scheduler: DispatchQueue.global())
            .tryMap { data in
                return try JSONDecoder().decode(ForecastData.self, from: data)
            }
            .mapError { error in
                return NetworkError.parsingValue
            }
            .eraseToAnyPublisher()
    }
    
    func getAirPollutionDataCombine(testingPath: String) -> AnyPublisher<AirPollutionData?, Error> {
        guard let lat_ = lat, let lon_ = lon else {
            print("Latitude and Longitude must be defined first")
            return Fail(error: NetworkError.request).eraseToAnyPublisher()
        }

        let path = testingPath.isEmpty ? UrlEndpoints.shared.airPollution : testingPath
        var requestable = CurrentWeatherRequest(apiVersion: .version_2_5, path: path)
        requestable.set(lat: lat_, lon: lon_)
        
        return serviceManager.getDataFromApiCombine(requestable: requestable)
//            .debounce(for: .seconds(1), scheduler: DispatchQueue.global())
            .tryMap { data in
                return try JSONDecoder().decode(AirPollutionData.self, from: data)
            }
            .mapError { error in
                return NetworkError.parsingValue
            }
            .eraseToAnyPublisher()
    }
    
}
