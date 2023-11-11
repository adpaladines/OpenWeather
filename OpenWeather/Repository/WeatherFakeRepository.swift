//
//  WeatherFakeRepository.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import CoreLocation
import Combine

class WeatherFakeRepository: Repositoryable {
    
    var serviceManager: Serviceable = JsonManager()
    var lat: String = "33.753746"
    var lon: String = "-84.386330"
    var isStubbingData: Bool = false
    
    private init() { }
    
    init(isStubbingData: Bool) {
        self.isStubbingData = isStubbingData
    }
    
    init(lat: String, lon: String, serviceManager: Serviceable) {
        self.lat = lat
        self.lon = lon
        self.serviceManager = serviceManager
    }
    
    func setServiceManager(_ serviceManager: Serviceable, and coordinate: CLLocationCoordinate2D) {
        print("No need to be defined for moking")
    }
    
    func getUrlForCurrentWeatherIn(city name: String, stateCode: String?, countryCode: String?, metrics: MeasurementUnit?) {
    }
    
    func getUrlStringImageBy(id: String) -> String? {
        "https://openweathermap.org/img/wn/10d@2x.png"
    }
    
    //MARK: Combine methods
    func getForecastDataCombine(metrics: MeasurementUnit?, testingPath: String) -> AnyPublisher<ForecastData?, Error> {
        guard !isStubbingData else {
            return Just(fiveDaysForecast)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        var requestable = CurrentWeatherRequest(apiVersion: .version_2_5, path: "fiveDaysForecast")
        requestable.set(lat: "50", lon: "50", metrics: .metric)
        return serviceManager.getDataFromApiCombine(requestable: requestable)
            .tryMap { data in
                return try JSONDecoder().decode(ForecastData.self, from: data)
            }
            .mapError { error in
                return NetworkError.parsingValue
            }
            .eraseToAnyPublisher()
    }
    
    func getAirPollutionDataCombine(testingPath: String) -> AnyPublisher<AirPollutionData?, Error> {
        return Just(airPollutionData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getCurrentWeatherCombine(metrics: MeasurementUnit?, testingPath: String) -> AnyPublisher<CurrentWeatherData?, Error> {
        guard !isStubbingData else {
            return Just(currentWeatherData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        var requestable = CurrentWeatherRequest(apiVersion: .test, path: "weather")
        requestable.set(lat: "50", lon: "50", metrics: .metric)
        return serviceManager.getDataFromApiCombine(requestable: requestable)
            .tryMap { data in
                return try JSONDecoder().decode(CurrentWeatherData.self, from: data)
            }
            .mapError { error in
                return NetworkError.parsingValue
            }
            .eraseToAnyPublisher()
    }
     
}

extension WeatherFakeRepository {
    
    var currentWeatherData: CurrentWeatherData {
        CurrentWeatherData(
            coord: CoordinateData(lat: 50, lon: 50),
            weather: [
                WeatherData(id: 1, main: "Raining", description: "moderate rain", icon: "10d")
            ],
            base: "stations",
            main: MainWeatherPart(temp: 21, feels_like: 22, temp_min: 19, temp_max: 26, pressure: 2, humidity: 8, sea_level: 13, grnd_level: 31),
            visibility: 50,
            wind: Wind(speed: 45, deg: 40),
            rain: Rain(the1H: 6.4, the3H: 19),
            snow: Snow(the1H: 12, the3H: 41),
            clouds: Clouds(all: 100),
            dt: 24,
            sys: Sys(type: 10, id: 101, country: "US", sunrise: 102, sunset: 23),
            timezone: 5,
            id: 3,
            name: "Atlanta",
            cod: 244)
    }
    
    var fiveDaysForecast: ForecastData {
        ForecastData(
            list: [
                DayForecastData(
                    dt: 1232310,
                    dt_txt: "1332-12-10",
                    main: MainWeatherPart(
                        temp: 12,
                        feels_like: 13,
                        temp_min: 11,
                        temp_max: 15,
                        pressure: 1,
                        humidity: 12,
                        sea_level: 144,
                        grnd_level: 1
                    ),
                    weather: [
                            WeatherData(id: 62, main: "mam", description: "desription for mam", icon: "10d"),
                            WeatherData(id: 63, main: "mams", description: "desription for mams", icon: "10e"),
                            WeatherData(id: 65, main: "mamsde", description: "desription for mamsde", icon: "10c"),
                            WeatherData(id: 67, main: "mamsd3", description: "desription for mamsd3", icon: "10b")
                        ]
                ),
                DayForecastData(
                    dt: 1232311,
                    dt_txt: "1332-12-11",
                    main: MainWeatherPart(
                        temp: 13,
                        feels_like: 13,
                        temp_min: 11,
                        temp_max: 15,
                        pressure: 1,
                        humidity: 12,
                        sea_level: 144,
                        grnd_level: 1
                    ),
                    weather: [
                            WeatherData(id: 42, main: "mam", description: "desription for mam", icon: "10d"),
                            WeatherData(id: 43, main: "mams", description: "desription for mams", icon: "10e"),
                            WeatherData(id: 45, main: "mamsde", description: "desription for mamsde", icon: "10c"),
                            WeatherData(id: 47, main: "mamsd3", description: "desription for mamsd3", icon: "10b")
                        ]
                ),
                DayForecastData(
                    dt: 1232312,
                    dt_txt: "1332-12-12",
                    main: MainWeatherPart(
                        temp: 14,
                        feels_like: 13,
                        temp_min: 11,
                        temp_max: 15,
                        pressure: 1,
                        humidity: 12,
                        sea_level: 144,
                        grnd_level: 1
                    ),
                    weather: [
                            WeatherData(id: 52, main: "mam", description: "desription for mam", icon: "10d"),
                            WeatherData(id: 53, main: "mams", description: "desription for mams", icon: "10e"),
                            WeatherData(id: 55, main: "mamsde", description: "desription for mamsde", icon: "10c"),
                            WeatherData(id: 57, main: "mamsd3", description: "desription for mamsd3", icon: "10b")
                        ]
                ),
                DayForecastData(
                    dt: 1232313,
                    dt_txt: "1332-12-13",
                    main: MainWeatherPart(
                        temp: 16,
                        feels_like: 13,
                        temp_min: 11,
                        temp_max: 15,
                        pressure: 1,
                        humidity: 12,
                        sea_level: 144,
                        grnd_level: 1
                    ),
                    weather: [
                            WeatherData(id: 12, main: "mam", description: "desription for mam", icon: "10d"),
                            WeatherData(id: 13, main: "mams", description: "desription for mams", icon: "10e"),
                            WeatherData(id: 15, main: "mamsde", description: "desription for mamsde", icon: "10c"),
                            WeatherData(id: 17, main: "mamsd3", description: "desription for mamsd3", icon: "10b")
                        ]
                ),
                DayForecastData(
                    dt: 1232314,
                    dt_txt: "1332-12-14",
                    main: MainWeatherPart(
                        temp: 12,
                        feels_like: 13,
                        temp_min: 11,
                        temp_max: 15,
                        pressure: 1,
                        humidity: 12,
                        sea_level: 144,
                        grnd_level: 1
                    ),
                    weather: [
                            WeatherData(id: 2, main: "mam", description: "desription for mam", icon: "10d"),
                            WeatherData(id: 3, main: "mams", description: "desription for mams", icon: "10e"),
                            WeatherData(id: 5, main: "mamsde", description: "desription for mamsde", icon: "10c"),
                            WeatherData(id: 7, main: "mamsd3", description: "desription for mamsd3", icon: "10b")
                        ]
                ),
                DayForecastData(
                    dt: 1232315,
                    dt_txt: "1332-12-15",
                    main: MainWeatherPart(
                        temp: 12,
                        feels_like: 13,
                        temp_min: 11,
                        temp_max: 15,
                        pressure: 1,
                        humidity: 12,
                        sea_level: 144,
                        grnd_level: 1
                    ),
                    weather: [
                            WeatherData(id: 22, main: "mam", description: "desription for mam", icon: "10d"),
                            WeatherData(id: 23, main: "mams", description: "desription for mams", icon: "10e"),
                            WeatherData(id: 25, main: "mamsde", description: "desription for mamsde", icon: "10c"),
                            WeatherData(id: 27, main: "mamsd3", description: "desription for mamsd3", icon: "10b")
                        ]
                ),
                DayForecastData(
                    dt: 1232316,
                    dt_txt: "1332-12-16",
                    main: MainWeatherPart(
                        temp: 12,
                        feels_like: 13,
                        temp_min: 11,
                        temp_max: 15,
                        pressure: 1,
                        humidity: 12,
                        sea_level: 144,
                        grnd_level: 1
                    ),
                    weather: [
                            WeatherData(id: 32, main: "mam", description: "desription for mam", icon: "10d"),
                            WeatherData(id: 33, main: "mams", description: "desription for mams", icon: "10e"),
                            WeatherData(id: 35, main: "mamsde", description: "desription for mamsde", icon: "10c"),
                            WeatherData(id: 37, main: "mamsd3", description: "desription for mamsd3", icon: "10b")
                        ]
                ),
            ],
            cod: "12334"
        )
    }
    
    var airPollutionData: AirPollutionData {
        AirPollutionData(
            coord: CoordinateData(lat: -12, lon: 88),
            list: [
                AirPollutionDataElement(
                    dt: 1413123,
                    main: AirPollutionDataMain(aqi: 2),
                    components: [
                        "co" : 2323,
                        "no" : 22,
                        "no2": 12,
                        "o3": 2222
                    ]
                )
            ]
        )
    }
}
