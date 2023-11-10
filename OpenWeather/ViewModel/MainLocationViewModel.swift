//
//  MainLocationViewModel.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI
import CoreLocation

enum AirQualityValue: String {
    case good = "Good"
    case fair = "Fair"
    case moderate = "Moderate"
    case poor = "Poor"
    case hazard = "Hazard"
}

class MainLocationViewModel: ObservableObject {
    
    @AppStorage("currentMeasurementUnit") var currentMeasurementUnit: String = MeasurementUnit.standard.rawValue
    
    @Published var customError: NetworkError?
    
    @Published var currentWeathrData: CurrentWeatherData?
    @Published var fiveForecastData: ForecastData?
    @Published var airPollutionData: AirPollutionData?
    
    private var repository: Repositoryable
    
    init(repository: Repositoryable) {
        self.repository = repository
    }
}

extension MainLocationViewModel: WeatherInfoProtocol {
    
    func getCurrentWeatherInfo(coordinate: CLLocationCoordinate2D) async {
        repository.setServiceManager(Services(), and: coordinate)
        do {
            let unit = MeasurementUnit(rawValue: currentMeasurementUnit)  ?? .standard
            let weatherData = try await repository.getCurrentWeather(metrics: unit, testingPath: "")
            DispatchQueue.main.async {
                self.currentWeathrData = weatherData
                self.customError = NetworkError.none
            }
        }catch {
            setCustomErrorStatus(with: error)
            print(error.localizedDescription)
        }
    }
    
    func getImageUrlBy(id: String?) -> String? {
        guard let id_ = id else {
            return nil
        }
        return repository.getUrlStringImageBy(id: id_)
    }
    
    func getDailyForecastInfo(coordinate: CLLocationCoordinate2D) async {
        repository.setServiceManager(Services(), and: coordinate)
        do {
            let unit = MeasurementUnit(rawValue: currentMeasurementUnit)  ?? .standard
            let forecastData = try await repository.getForecastData(metrics: unit, testingPath: "")
            DispatchQueue.main.async {
                self.fiveForecastData = forecastData
                self.customError = NetworkError.none
            }
        }catch {
            setCustomErrorStatus(with: error)
        }
    }
    
    func getAirPollutionData(coordinate: CLLocationCoordinate2D) async {
        repository.setServiceManager(Services(), and: coordinate)
        do {
            let airPollutionData = try await repository.getAirPollutionData(testingPath: "")
            DispatchQueue.main.async {
                self.airPollutionData = airPollutionData
                self.customError = NetworkError.none
            }
        }catch {
            setCustomErrorStatus(with: error)
        }
    }
    
    var currentWeatherIconUrl: URL? {
        guard let imageUrlString = self.getImageUrlBy(id: self.currentWeathrData?.weather.first?.icon),
              let imageUrl = URL(string: imageUrlString) else {return nil}
        return imageUrl
    }
    
    func setCustomErrorStatus(with error: Error) {
        switch error {
        case is DecodingError:
            customError = NetworkError.parsingValue
        case is URLError:
            customError = .invalidUrl
        case NetworkError.dataNotFound:
            customError = NetworkError.dataNotFound
        case NetworkError.response:
            customError = NetworkError.response(error._code)
        case is CancellationError:
            customError = .dataNotFound
            print("CancellationError")
        default:
            customError = .dataNotFound
        }
    }
}

//MARK: Widget lists (computed properties)
extension MainLocationViewModel {
    
    var miniWidgets: Array<MiniWidgetData> {
        var widgets = Array<MiniWidgetData>()
        if let item = currentWind {
            widgets.append(MiniWidgetData(title: "Wind speed".localized(), systemIcon: "wind", value: item.speed.stringValue+"m/s", caption: item.deg.stringValue + "°"))
        }
        if let item = currentRain {
            if let oneHour = item.the1H {
                widgets.append(MiniWidgetData(title: "Rain volume 1h".localized(), systemIcon: "cloud.rain", value: oneHour.description+"mm³", caption: ""))
            }
            if let threeHours = item.the3H {
                widgets.append(MiniWidgetData(title: "Rain volume 3h".localized(), systemIcon: "cloud.rain", value: threeHours.description+"mm³", caption: ""))
            }
            
        }
        if let item = currentSnow {
            if let oneHour = item.the1H {
                widgets.append(MiniWidgetData(title: "Snow volume 1h".localized(), systemIcon: "snowflake", value: oneHour.description+"mm³", caption: ""))
            }
            if let threeHours = item.the3H {
                widgets.append(MiniWidgetData(title: "Snow volume 3h".localized(), systemIcon: "snowflake", value: threeHours.description+"mm³", caption: ""))
            }
        }
        if let item = pressure {
            widgets.append(MiniWidgetData(title: "Pressure".localized(), systemIcon: "rectangle.compress.vertical", value: item.description+"hPa", caption: ""))
        }
        if let item = sunRise {
            widgets.append(MiniWidgetData(title: "Sunrise".localized(), systemIcon: "sunrise", value: item, caption: ""))
        }
        if let item = sunSet {
            widgets.append(MiniWidgetData(title: "Sunset".localized(), systemIcon: "sunset", value: item, caption: ""))
        }
        return widgets
    }
    
    var miniWidgetsAirQuality: Array<MiniGaugeData> {
        var widgets = Array<MiniGaugeData>()
        if let item = airPollutionData?.list.first?.main.aqi {
            let title: String
            let color: Color
            let progress: Double
            switch item {
            case 1: color = .gray; title = AirQualityValue.good.rawValue.localized(); progress = 0.2
            case 2: color = .green; title = AirQualityValue.fair.rawValue.localized(); progress = 0.4
            case 3: color = .yellow; title = AirQualityValue.moderate.rawValue.localized(); progress = 0.6
            case 4: color = .orange; title = AirQualityValue.poor.rawValue.localized(); progress = 0.8
            default: color = .red; title = AirQualityValue.hazard.rawValue.localized(); progress = 1.0
            }
            widgets.append(MiniGaugeData(title: title, progressValue: progress, color: color, size: .small, legendPosition: .bottom, legend: "AQI"))
        }
        
        if let item = airPollutionData?.list.first?.so2 {
            let title: String
            let color: Color
            let progress: Double
            switch item {
            case 0...20: color = .gray; title = AirQualityValue.good.rawValue.localized(); progress = 0.2
            case 21...80: color = .green; title = AirQualityValue.fair.rawValue.localized(); progress = 0.4
            case 81...250: color = .yellow; title = AirQualityValue.moderate.rawValue.localized(); progress = 0.6
            case 250...350: color = .orange; title = AirQualityValue.poor.rawValue.localized(); progress = 0.8
            default: color = .red; title = AirQualityValue.hazard.rawValue.localized(); progress = 1.0
            }
            widgets.append(MiniGaugeData(title: title, progressValue: progress, color: color, size: .small, legendPosition: .bottom, legend: "SO2"))
        }
        
        if let item = airPollutionData?.list.first?.no2 {
            let title: String
            let color: Color
            let progress: Double
            switch item {
            case 0...40: color = .gray; title = AirQualityValue.good.rawValue.localized(); progress = 0.2
            case 41...70: color = .green; title = AirQualityValue.fair.rawValue.localized(); progress = 0.4
            case 71...150: color = .yellow; title = AirQualityValue.moderate.rawValue.localized(); progress = 0.6
            case 151...200: color = .orange; title = AirQualityValue.poor.rawValue.localized(); progress = 0.8
            default: color = .red; title = AirQualityValue.hazard.rawValue.localized(); progress = 1.0
            }
            widgets.append(MiniGaugeData(title: title, progressValue: progress, color: color, size: .small, legendPosition: .bottom, legend: "NO2"))
        }
        
        if let item = airPollutionData?.list.first?.pm10 {
            let title: String
            let color: Color
            let progress: Double
            switch item {
            case 0...20: color = .gray; title = AirQualityValue.good.rawValue.localized(); progress = 0.2
            case 21...50: color = .green; title = AirQualityValue.fair.rawValue.localized(); progress = 0.4
            case 51...100: color = .yellow; title = AirQualityValue.moderate.rawValue.localized(); progress = 0.6
            case 101...200: color = .orange; title = AirQualityValue.poor.rawValue.localized(); progress = 0.8
            default: color = .red; title = AirQualityValue.hazard.rawValue.localized(); progress = 1.0
            }
            widgets.append(MiniGaugeData(title: title, progressValue: progress, color: color, size: .small, legendPosition: .bottom, legend: "PM10"))
        }
        
        if let item = airPollutionData?.list.first?.pm2_5 {
            let title: String
            let color: Color
            let progress: Double
            switch item {
            case 0...10: color = .gray; title = AirQualityValue.good.rawValue.localized(); progress = 0.2
            case 11...25: color = .green; title = AirQualityValue.fair.rawValue.localized(); progress = 0.4
            case 26...50: color = .yellow; title = AirQualityValue.moderate.rawValue.localized(); progress = 0.6
            case 51...75: color = .orange; title = AirQualityValue.poor.rawValue.localized(); progress = 0.8
            default: color = .red; title = AirQualityValue.hazard.rawValue.localized(); progress = 1.0
            }
            widgets.append(MiniGaugeData(title: title, progressValue: progress, color: color, size: .small, legendPosition: .bottom, legend: "PM2.5"))
        }
        
        if let item = airPollutionData?.list.first?.o3 {
            let title: String
            let color: Color
            let progress: Double
            switch item {
            case 0...60: color = .gray; title = AirQualityValue.good.rawValue.localized(); progress = 0.2
            case 61...100: color = .green; title = AirQualityValue.fair.rawValue.localized(); progress = 0.4
            case 101...140: color = .yellow; title = AirQualityValue.moderate.rawValue.localized(); progress = 0.6
            case 141...180: color = .orange; title = AirQualityValue.poor.rawValue.localized(); progress = 0.8
            default: color = .red; title = AirQualityValue.hazard.rawValue.localized(); progress = 1.0
            }
            widgets.append(MiniGaugeData(title: title, progressValue: progress, color: color, size: .small, legendPosition: .bottom, legend: "O3"))
        }
        
        if let item = airPollutionData?.list.first?.co {
            let title: String
            let color: Color
            let progress: Double
            switch item {
            case 0...4400: color = .gray; title = AirQualityValue.good.rawValue.localized(); progress = 0.2
            case 4401...9400: color = .green; title = AirQualityValue.fair.rawValue.localized(); progress = 0.4
            case 9401...12400: color = .yellow; title = AirQualityValue.moderate.rawValue.localized(); progress = 0.6
            case 12401...15400: color = .orange; title = AirQualityValue.poor.rawValue.localized(); progress = 0.8
            default: color = .red; title = AirQualityValue.hazard.rawValue.localized(); progress = 1.0
            }
            widgets.append(MiniGaugeData(title: title, progressValue: progress, color: color, size: .small, legendPosition: .bottom, legend: "CO"))
        }
        return widgets
    }
}

//MARK: Private computed properties
extension MainLocationViewModel {
    
    fileprivate var currentWind: Wind? {
        currentWeathrData?.wind
    }
    
    fileprivate var currentRain: Rain? {
        currentWeathrData?.rain
    }
    
    fileprivate var currentSnow: Snow? {
        currentWeathrData?.snow
    }
    
    fileprivate var pressure: Int? {
        currentWeathrData?.main.pressure
    }
    
    fileprivate var sunRise: String? {
        currentWeathrData?.sys?.sunrise?.timestampToHourMinuteString
    }
    
    fileprivate var sunSet: String? {
        currentWeathrData?.sys?.sunset?.timestampToHourMinuteString
    }
    
}