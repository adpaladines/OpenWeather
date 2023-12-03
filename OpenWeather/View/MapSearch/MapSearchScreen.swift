//
//  MapSearchScreen.swift
//  OpenWeather
//
//  Created by andres paladines on 10/27/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct CitySearchScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeColor: ThemeColor
    
    @StateObject private var searchManager = MapSearchManager()
    @StateObject private var mapCoordinatesViewModel = MapCoordinatesViewModel()
    
    @Binding var selectedCityName: String
    
//    @State private var selectedObject: MKLocalSearchCompletion?
    @State private var showActionSheet = false
    @State private var navigateToMapScreen = false
    @State private var chargingLocation = false
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(themeColor.containerBackground)
                .overlay {
                    HStack {
                        TextField("Search your city".localized(), text: $searchManager.searchTerm)
                            .padding(.horizontal, 16)
                            .frame(height: 36)
                    }
                }
                .cornerRadius(12)
                .frame(height: 44)
                .background(.clear)
                .padding()
            ScrollView {
                LazyVGrid(columns: [GridItem.init()]) {
                    ForEach(searchManager.locationResults, id: \.title) { result in
                        VStack(alignment: .leading) {
                            Text(result.title)
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundStyle(themeColor.text)
                            Divider()
                        }
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded { _ in
                                    searchManager.selectedObject = result
//                                    selectedObject = result
                                    showActionSheet = true
                                }
                        )
                        .padding()
                    }
                }
                .background(themeColor.containerBackground)
                .cornerRadius(12)
                .background(.clear)
            }
            .cornerRadius(12)
        }
        .background(themeColor.screenBackground)
        .preferredColorScheme(themeColor.colorScheme)
        .navigationTitle(Text("City search".localized()))
        .confirmationDialog(
            searchManager.confirmDialogString,
            isPresented: $showActionSheet,
            titleVisibility: Visibility.visible
        ) {
            Button("Select as default".localized()) {
                guard
                    let obj = searchManager.selectedObject,
                    searchManager.cityName.isNotEmpty
                else {
                    navigateToMapScreen = false
                    return
                }
                chargingLocation = true
                mapCoordinatesViewModel.reconcileLocation(location: obj)
            }

            Button("View in Map".localized()) {
                if searchManager.selectedObject != nil {
                    navigateToMapScreen = true
                }
            }
            Button("Cancel".localized(), role: .cancel) { }
        }
        .navigationDestination(
            isPresented: $navigateToMapScreen,
            destination: {
                MapCoordinatesScreen(locationResult: searchManager.selectedObject ?? MKLocalSearchCompletion())
            }
        )
        .onChange(of: mapCoordinatesViewModel.coordinate) { newValue in
            selectedCityName = searchManager.cityName
            chargingLocation = false
            print(searchManager.cityName)
            guard let cityCoordinates = newValue else { return }
            print(cityCoordinates)
            dismiss()
        }
    }
}

#Preview {
    CitySearchScreen(selectedCityName: .constant("Deerfield Beach"))
        .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
}
