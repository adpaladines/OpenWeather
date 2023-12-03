//
//  MapCoordinatesViewModel.swift
//  OpenWeather
//
//  Created by andres paladines on 11/29/23.
//

import Foundation
import Combine
import CoreLocation
import MapKit

class MapCoordinatesViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var coordinate: CLLocationCoordinate2D?
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
