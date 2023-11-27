//
//  LocationManager.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    
    @Published var currentLocation: CLLocation?
    @Published var locationPermissionError: Bool = false
    
    private let cllocationManager = CLLocationManager()
    private var cancellables: Set<AnyCancellable> = []
    
    
    private var locationSubject = PassthroughSubject<CLLocation, Never>()

    override init() {
        super.init()
        
        cllocationManager.delegate = self

        // Combine permissions check and location updates
        Future<Bool, Never> { promise in
            self.checkLocationPermissions { result in
                promise(.success(result))
            }
        }
        .sink { [weak self] hasPermission in
            if hasPermission {
                self?.startUpdatingLocation()
            } else {
                // Handle lack of permissions, show an alert, etc.
            }
        }
        .store(in: &cancellables)

        // Connect the locationSubject to the didUpdateLocations callback
        locationSubject
            .throttle(for: 2, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] location in
                self?.currentLocation = location
            }
            .store(in: &cancellables)
    }

    func startUpdatingLocation() {
        DispatchQueue.main.async {
            self.cllocationManager.requestWhenInUseAuthorization()
            self.cllocationManager.startUpdatingLocation()
        }
    }

    func stopUpdatingLocation() {
        DispatchQueue.main.async {
            self.cllocationManager.stopUpdatingLocation()
        }
    }
    
    private func checkLocationPermissions(completion: @escaping (Bool) -> Void) {
        if CLLocationManager.locationServicesEnabled() {
            switch cllocationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                completion(true)
            case .denied, .restricted:
                completion(false)
            case .notDetermined:
                // Ask for permission
                cllocationManager.requestWhenInUseAuthorization()
                completion(false)
            @unknown default:
                completion(false)
            }
        } else {
            completion(false)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        // Publish the location update to the subject
        locationSubject.send(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

/*
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
*/
