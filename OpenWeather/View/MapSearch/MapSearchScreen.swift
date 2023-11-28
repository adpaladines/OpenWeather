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
    @StateObject private var mapSearch = MapSearchManager()
    
    @Binding var selectedCityName: String
    
//    @State private var selectedObject: MKLocalSearchCompletion?
    @State private var showActionSheet = false
    @State private var navigateToMapScreen = false

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(themeColor.containerBackground)
                .overlay {
                    HStack {
                        TextField("Address", text: $mapSearch.searchTerm)
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
                    ForEach(mapSearch.locationResults, id: \.title) { result in
                        VStack(alignment: .leading) {
                            Text(result.title)
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundStyle(themeColor.text)
                            Divider()
                        }
                        .gesture(
                            TapGesture()
                                .onEnded { value in
                                    print(value)
                                    mapSearch.selectedObject = result
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
        .navigationTitle(Text("Address search"))
        .confirmationDialog(
            mapSearch.selectedObject != nil ? "Options for: \n\(mapSearch.selectedObject!.title)" : "Options:",
            isPresented: $showActionSheet,
            titleVisibility: Visibility.visible
        ) {
            Button("Select as default") {
                guard 
                    mapSearch.selectedObject != nil,
                    mapSearch.cityName.isNotEmpty
                else {
                    navigateToMapScreen = false
                    return
                }
                selectedCityName = mapSearch.cityName
                dismiss()
                print(mapSearch.cityName)
            }

            Button("View in Map") {
                if mapSearch.selectedObject != nil {
                    navigateToMapScreen = true
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .navigationDestination(
            isPresented: $navigateToMapScreen,
            destination: {
                DetailScreen(locationResult: mapSearch.selectedObject ?? MKLocalSearchCompletion())
            }
        )
    }
}

class DetailViewModel: ObservableObject {
    @Published var isLoading = true
    @Published private var coordinate : CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    
    var coordinateForMap : CLLocationCoordinate2D {
        coordinate ?? CLLocationCoordinate2D()
    }
    
    func reconcileLocation(location: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if error == nil, let coordinate = response?.mapItems.first?.placemark.coordinate {
                self.coordinate = coordinate
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.3,
                        longitudeDelta: 0.3
                    )
                )
                self.isLoading = false
            }
        }
    }
    
    func clear() {
        isLoading = true
    }
}

struct DetailScreen : View {
    
    @EnvironmentObject var themeColor: ThemeColor
    
    var locationResult : MKLocalSearchCompletion
    @StateObject private var viewModel = DetailViewModel()
    
    struct Marker: Identifiable {
        let id = UUID()
        var location: MapMarker
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                Text("Loading...")
            } else {
                Map(
                    coordinateRegion: $viewModel.region,
                    annotationItems:
                        [
                            Marker(
                                location: MapMarker(
                                    coordinate: viewModel.coordinateForMap,
                                    tint: themeColor.button
                                )
                            )
                        ]
                ) { (marker) in
                    marker.location
                }
            }
        }.onAppear {
            viewModel.reconcileLocation(location: locationResult)
        }.onDisappear {
            viewModel.clear()
        }
        .navigationTitle(Text(locationResult.title))
    }
}

#Preview {
    CitySearchScreen(selectedCityName: .constant("Deerfield Beach"))
        .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
}
