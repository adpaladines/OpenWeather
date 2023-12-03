//
//  LocationManager.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocation?
    @Published var locationError: LocationError = .none

    private var permissionManager: LocationPermissionManager
    private var locationManager: CLLocationManager
    internal var cancellables: Set<AnyCancellable> = []

    init(permissionManager: LocationPermissionManager) {
        self.permissionManager = permissionManager
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        setupBindings()
    }
    
    private func setupBindings() {
        permissionManager.$permissionStatus
            .sink { [weak self] status in
                self?.handlePermissionStatus(status)
            }
            .store(in: &cancellables)
    }
    
    func startLocationUpdates() {
        guard permissionManager.permissionStatus != .authorized else {
//            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
            return
        }
        requestLocationAccess(authorizationType: .whenInUse)
    }

    func requestLocationAccess(authorizationType: LocationAuthorizationType) {
        DispatchQueue.global().async {
            self.permissionManager.requestLocationAccess(authorizationType: authorizationType)
        }
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = .undetermined
    }

    // Handle changes in permission status
    private func handlePermissionStatus(_ status: PermissionStatus) {
        switch status {
        case .authorized: locationError = .none
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            locationError = LocationError.permissionDenied
        default:
            break
        }
    }
}

enum LocationError: Error {
    case unauthorized
    case permissionDenied
    case none
    case undetermined
}
extension LocationError: LocalizedError, Equatable {
        
    var errorDescription: String? {
        let localizedString: String
        let reflectionString = String(reflecting: self)
        switch self {
        case .unauthorized:
            localizedString = NSLocalizedString("Location permission was not authorized. \nPlease go to settings, find the name of this app and set location permission again.".localized(), comment: reflectionString)
        case .permissionDenied:
            localizedString = NSLocalizedString("Location permission was denied previously.\nPlease go to settings, find the name of this app and set location permission again.".localized(), comment: reflectionString)
        case .none:
            localizedString = NSLocalizedString("No problem set.".localized(), comment: reflectionString)
        case .undetermined:
            localizedString = NSLocalizedString("Undetermined error while locating your position.\nPlease go to settings, find the name of this app and set location permission again.\nIf the problem persists, concact to developer's email.".localized(), comment: reflectionString)
        }
        return localizedString
    }
    
}
