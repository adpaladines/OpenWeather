//
//  PermissionManager.swift
//  OpenWeather
//
//  Created by andres paladines on 11/27/23.
//

import Combine
import CoreLocation

enum LocationAuthorizationType {
    case whenInUse
    case always
}

enum PermissionStatus: Equatable {
    static func == (lhs: PermissionStatus, rhs: PermissionStatus) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
    
    case denied
    case authorized
    case notDetermined
    case restricted
}


protocol PermissionManager {
    var permissionStatus: PermissionStatus { get }
    var cancellables: Set<AnyCancellable> { get }
    func requestLocationAccess(authorizationType: LocationAuthorizationType)
    func getLocationStatus(_ status: CLAuthorizationStatus) -> PermissionStatus
}

class LocationPermissionManager: NSObject, ObservableObject, CLLocationManagerDelegate, PermissionManager {
    @Published private(set) var permissionStatus: PermissionStatus = .notDetermined
    
    internal var cancellables: Set<AnyCancellable> = []
    
    func requestLocationAccess(authorizationType: LocationAuthorizationType) {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        guard CLLocationManager.locationServicesEnabled() else {
            permissionStatus = .authorized
            return
        }
        
        switch authorizationType {
        case .whenInUse:
            locationManager.requestWhenInUseAuthorization()
            
        case .always:
            locationManager.requestAlwaysAuthorization()
        }
        
        // Combine the authorization status changes
        $permissionStatus
            .filter { $0 != PermissionStatus.notDetermined }
            .prefix(1)
            .sink { status in
                // Perform any additional actions on status change if needed
            }
            .store(in: &cancellables)
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let newStatus = getLocationStatus(status)
        permissionStatus = newStatus
    }
    
    func getLocationStatus(_ status: CLAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        @unknown default:
            return .notDetermined
        }
    }
    
}



