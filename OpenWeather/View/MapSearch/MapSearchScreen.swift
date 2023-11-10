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
    
    @EnvironmentObject var themeColor: ThemeColor
    @StateObject private var mapSearch = MapSearchManager()
    
    @Binding var selectedCityName: String
    
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
//                    ForEach(mapSearch.locationResults, id: \.self) { location in
                    ForEach(mapSearch.locationResultStrings, id: \.self) { location in
//                        NavigationLink(destination: Detail(locationResult: location)) {
                        VStack(alignment: .leading) {
//                                Text(location.title)
                            Text(location)
                                .foregroundStyle(themeColor.text)
                            Divider()
                        }
                        .gesture(
                            TapGesture()
                                .onEnded { value in
                                    print(value)
                                }
                        )
                        .padding()
//                        }
                    }
                }
                .cornerRadius(12)
//                .background(themeColor.containerBackground)
                .background(.clear)
            }
            .cornerRadius(12)
            
        }
        .background(themeColor.screenBackground)
        .preferredColorScheme(themeColor.colorScheme)
        .navigationTitle(Text("Address search"))
        
    }
}

class DetailViewModel : ObservableObject {
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
                self.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
                self.isLoading = false
            }
        }
    }
    
    func clear() {
        isLoading = true
    }
}

struct Detail : View {
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
                Map(coordinateRegion: $viewModel.region,
                    annotationItems: [Marker(location: MapMarker(coordinate: viewModel.coordinateForMap))]) { (marker) in
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
