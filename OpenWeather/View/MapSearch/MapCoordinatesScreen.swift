//
//  MapCoordinatesScreen.swift
//  OpenWeather
//
//  Created by andres paladines on 11/29/23.
//

import SwiftUI
import MapKit

struct MapCoordinatesScreen: View {
    
    @EnvironmentObject var themeColor: ThemeColor
    
    var locationResult : MKLocalSearchCompletion
    @StateObject private var viewModel = MapCoordinatesViewModel()
    
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
    MapCoordinatesScreen(locationResult: MKLocalSearchCompletion())
        .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
}
