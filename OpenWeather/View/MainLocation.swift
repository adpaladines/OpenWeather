//
//  MainLocation.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI
import CoreLocation

enum LocationType {
    case cityName(city: String)
    case currentLocation
}

struct MainLocationScreen: View {
    
    @EnvironmentObject var themeColor: ThemeColor
    
    @StateObject var locationManager = LocationManager(permissionManager: LocationPermissionManager())
    @StateObject var viewModel: MainLocationViewModel
    
    @State private var isClosedCurrentWeather = false
    @State private var isClosedAirQuality = false
    @State private var isClosedForecast = false
    @State private var isLoading = true
    @State var locationTypeSelected: LocationType = .currentLocation
    
    @State var selectedCityName: String
    
    var isForTesting: Bool?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                MainCitySearchBarView(
                    selectedCityName: $selectedCityName,
                    cityName: viewModel.currentWeathrData?.name
                )
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
//            RefreshableScrollView(onRefresh: refreshData) {
//                VStack(spacing: 16) {
                    //                if let error = viewModel.customError, error != .none {
                    MissingApiKeyView(error: viewModel.customError ?? .none)
                        .padding(.top, 36)
                        .opacity((viewModel.customError ?? .none) != NetworkError.none ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.customError)
                        .frame(
                            height: (viewModel.customError ?? .none) != NetworkError.none ? nil : 0,
                            alignment: .center)
                    //                }
                    
                    if viewModel.fiveForecastData?.list.count ?? 0 > 0 {
                        FiveDaysForecastbarView(viewModel: viewModel, isClosed: $isClosedForecast)
                            .containerBackground(withColor: themeColor.containerBackground)
                            .frame(maxWidth: 640)
                            .padding(.horizontal)
                            .padding(.top)
                    }
                    
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
                    
//                }
            }
            .refreshable {
                refreshData()
            }
            .frame(maxWidth: .infinity)	
            .background(themeColor.screenBackground)
            .onChange(of: viewModel.customError) { newValue in
                isLoading = false
                guard newValue != nil else { return }
                locationManager.stopLocationUpdates()
            }
            .onChange(of: viewModel.currentMeasurementUnit) { newValue in
                viewModel.customError = nil
                locationManager.startLocationUpdates()
            }
            .onChange(of: locationManager.currentLocation) {
                newValue in
                Task {
                    locationManager.stopLocationUpdates()
                    guard let error = viewModel.customError else {
                        await getweatherData(coordinate: newValue?.coordinate)
                        return
                    }
                    
                    if error != NetworkError.none {
                        await getweatherData(coordinate: newValue?.coordinate)
                    }
                }
            }
            .onAppear {
                refreshData()
            }
            .onChange(of: selectedCityName) { newValue in
                print("CHANGE CAME HERE: \(newValue)")
            }
        }
    }
    
    func refreshData() {
        viewModel.customError = nil
        locationManager.startLocationUpdates()
    }
    
    func getweatherData(coordinate: CLLocationCoordinate2D?) async  {
        if let coord = coordinate {
            viewModel.fetchServerData(coordinate: coord)
//            viewModel.getCurrentWeatherInfoCombine(coordinate: coord)
//            viewModel.getDailyForecastInfoCombine(coordinate: coord)
//            viewModel.getAirPollutionDataCombine(coordinate: coord)
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
            ), 
            selectedCityName: "Deerfield Beach", 
            isForTesting: true
        )
        
        return contentView
            .environmentObject(ThemeColor(appTheme: "light"))
            .environmentObject(CurrentLanguage(code: "es"))

    }
}
