//
//  MainLocation.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI
import CoreLocation

struct MainLocationScreen: View {
    
    @EnvironmentObject var themeColor: ThemeColor
    
    @StateObject var locationManager = LocationManager()
    @StateObject var viewModel: MainLocationViewModel
    
    @State private var isClosedCurrentWeather = false
    @State private var isClosedAirQuality = false
    @State private var isClosedForecast = false
    @State private var isLoading = true
    
    var isForTesting: Bool?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                
                MainCitySearchBarView(cityName: viewModel.currentWeathrData?.name)
                    .padding()
                MainTemperatureBarView(
                    temperature: viewModel.currentWeathrData?.main.temp,
                    feelsLike: viewModel.currentWeathrData?.main.feels_like,
                    iconUrl: viewModel.currentWeatherIconUrl
                )
                .padding(.horizontal)
                .padding(.bottom)
//                .makeSecureTextField()
            }
            .background(themeColor.containerBackground)
            
            ScrollView(showsIndicators: false) {
                
                FiveDaysForecastbarView(viewModel: viewModel, isClosed: $isClosedForecast)
                    .containerBackground(withColor: themeColor.containerBackground)
                    .frame(maxWidth: 640)
                    .padding(.horizontal)
                    .padding(.top)
                
                if viewModel.miniWidgets.count > 0 {
                    CollapsibleHeaderView(title: "Today's info".localized(), image: Image(systemName: "info.circle"), isClosed: $isClosedCurrentWeather)
                        .containerBackground(withColor: themeColor.containerBackground)
                        .frame(maxWidth: 640)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    MainMiniWidgetsGridView(isClosed: $isClosedCurrentWeather, miniWidgets: viewModel.miniWidgets)
                        .frame(maxWidth: 645)
                        .padding(.bottom)
                        .padding(.horizontal)
                }
                
                if viewModel.miniWidgetsAirQuality.count > 0 {
                    CollapsibleHeaderView(title: "Air Quality info".localized(), image: Image(systemName: "wind.circle"), isClosed: $isClosedAirQuality)
                        .containerBackground(withColor: themeColor.containerBackground)
                        .frame(maxWidth: 640)
                        .padding(.horizontal)
                    
                    MiniWidgetsAirQualityGridView(isClosed: $isClosedAirQuality, miniGauges: viewModel.miniWidgetsAirQuality)
                        .frame(maxWidth: 640)
                        .padding(.bottom)
                        .padding(.horizontal)
                        .redacted(reason: isLoading ? .placeholder: [])
                }
            }
            .frame(maxWidth: .infinity)
            .background(themeColor.screenBackground)
            .onChange(of: viewModel.customError, perform: { newValue in
                isLoading = false
                guard newValue != nil else { return }
                locationManager.stopUpdatingLocation()
            })
            .onChange(of: viewModel.currentMeasurementUnit, perform: { newValue in
                viewModel.customError = nil
                locationManager.startUpdatingLocation()
            })
            .onChange(of: locationManager.currentLocation, perform: {
                newValue in
                Task {
                    guard let error = viewModel.customError else {
                        await getweatherData(coordinate: newValue?.coordinate)
                        return
                    }
                    
                    if error != NetworkError.none {
                        await getweatherData(coordinate: newValue?.coordinate)
                    }
                }
            })
            .task {
                if isForTesting ?? false {
                    let coord = CLLocationCoordinate2D(latitude: 51.50998, longitude: -0.1337)
                    await viewModel.getCurrentWeatherInfo(coordinate: coord)
                    await viewModel.getDailyForecastInfo(coordinate: coord)
                    await viewModel.getAirPollutionData(coordinate: coord)
                }
            }
            .refreshable {
                viewModel.customError = nil
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func getweatherData(coordinate: CLLocationCoordinate2D?) async  {
        if let coordinate_ = coordinate {
            await viewModel.getCurrentWeatherInfo(coordinate: coordinate_)
            await viewModel.getDailyForecastInfo(coordinate: coordinate_)
            await viewModel.getAirPollutionData(coordinate: coordinate_)
        }
    }
}

struct MainLocationScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let contentView = MainLocationScreen(
            viewModel: MainLocationViewModel(
                repository: WeatherFakeRepository(
                    isStubbingData: true
                )
            ), isForTesting: true
        )
        return contentView
            .environmentObject(ThemeColor(appTheme: "light"))
            .environmentObject(CurrentLanguage(code: "es"))

    }
}
