//
//  LocationManager.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    
    @Published var currentLocation: CLLocation?
    
    private let cllocationManager = CLLocationManager()
    
    override init() {
        super.init()
        // First of all, we will request permissions.
        cllocationManager.requestWhenInUseAuthorization()
        cllocationManager.delegate = self
        startUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        DispatchQueue.main.async {
            self.cllocationManager.startUpdatingLocation()
        }
    }
    
    func stopUpdatingLocation() {
        DispatchQueue.main.async {
            self.cllocationManager.stopUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard currentLocation != locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
