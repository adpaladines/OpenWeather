//
//  PermissionManager.swift
//  OpenWeather
//
//  Created by andres paladines on 11/27/23.
//

import Combine
import CoreLocation
import AVFoundation
import UIKit
import Photos
import Contacts

enum PermissionType {
//    case cameraUsage
//    case contactUsage
//    case photoLibraryUsage
    case locationUsage
}

class PermissionManager {

    private init(){}
    public static let shared = PermissionManager()
    
//    let PHOTO_LIBRARY_PERMISSION: String = "Require access to Photo library to proceed. Would you like to open settings and grant permission to photo library?"
//    let CAMERA_USAGE_PERMISSION: String = "Require access to Camera to proceed. Would you like to open settings and grant permission to camera ?"
//    let CONTACT_USAGE_ALERT: String = "Require access to Contact to proceed. Would you like to open Settings and grant permission to Contact?"
//    let MICROPHONE_USAGE_ALERT: String = "Require access to microphone to proceed. Would you like to open Settings and grant permissiont to Microphone?"
    let LOCATION_USAGE_ALERT: String = "Require access to microphone to proceed. Would you like to open Settings and grant permissiont to Microphone?"

    
    
    func requestAccess(
        vc: UIViewController,
        _ permission: PermissionType,
        completionHandler: @escaping (_ accessGranted: Bool) -> Void
    ) {
        
        switch permission {
        case .locationUsage:break
            /*
             case .cameraUsage:
             let permissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
             switch permissionStatus {
             case .authorized:
             completionHandler(true)
             case .denied:
             showSettingsAlert(controller: vc, msg: CAMERA_USAGE_PERMISSION, completionHandler)
             case .restricted, .notDetermined:
             requestAVCaptureAccess(vc: vc, completionHandler: completionHandler)
             @unknown default:
             requestAVCaptureAccess(vc: vc, completionHandler: completionHandler)
             }
             break
             
             
             case .contactUsage:
             switch CNContactStore.authorizationStatus(for: .contacts) {
             case .authorized:
             completionHandler(true)
             case .denied:
             showSettingsAlert(controller: vc, msg: CONTACT_USAGE_ALERT, completionHandler)
             case .restricted, .notDetermined:
             requestContactsAccess(vc: vc, completionHandler: completionHandler)
             @unknown default:
             requestContactsAccess(vc: vc, completionHandler: completionHandler)
             }
             break
             
             case .photoLibraryUsage:
             switch PHPhotoLibrary.authorizationStatus() {
             case .authorized:
             completionHandler(true)
             case .denied:
             showSettingsAlert(controller: vc, msg: PHOTO_LIBRARY_PERMISSION, completionHandler)
             case .restricted, .notDetermined, .limited:
             requestPhotoLibraryAccess(vc: vc, completionHandler: completionHandler)
             @unknown default:
             requestPhotoLibraryAccess(vc: vc, completionHandler: completionHandler)
             }
             break
             */
            
        }
    }
    
    
    
    private func showSettingsAlert(
        controller: UIViewController ,
        msg: String,
        _ completionHandler: @escaping (_ accessGranted: Bool) -> Void
    ) {
        
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            completionHandler(false)
            
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsUrl){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl)
                    } else {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        controller.present(alert, animated: true)
    }
    
    
//    func requestAVCaptureAccess(vc: UIViewController, completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
//        AVCaptureDevice.requestAccess(for: .video) { granted in
//            if granted {
//                completionHandler(true)
//            } else {
//                DispatchQueue.main.async {
//                    self.showSettingsAlert(controller: vc, msg: self.CAMERA_USAGE_PERMISSION, completionHandler)
//                }
//            }
//        }
//    }
    
//    func requestContactsAccess(vc: UIViewController, completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
//        CNContactStore.init().requestAccess(for: .contacts) { granted, error in
//            if granted {
//                completionHandler(true)
//            } else {
//                DispatchQueue.main.async {
//                    self.showSettingsAlert(controller: vc, msg: self.CONTACT_USAGE_ALERT, completionHandler)
//                }
//            }
//        }
//    }
    
//    func requestPhotoLibraryAccess(vc: UIViewController, completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
//        PHPhotoLibrary.requestAuthorization { status in
//            if status == .authorized {
//                completionHandler(true)
//            }else {
//                DispatchQueue.main.async {
//                    self.showSettingsAlert(controller: vc, msg: self.PHOTO_LIBRARY_PERMISSION, completionHandler)
//                }
//            }
//        }
//    }
    
    enum LocationAuthorizationType {
        case whenInUse
        case always
    }
    
    enum PermissionStatus {
        case denied
        case authorized
        case notDetermined
        case restricted
    }
    
    class LocationPermissionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
        @Published private(set) var permissionStatus: PermissionStatus = .notDetermined
        
        private var cancellables: Set<AnyCancellable> = []
        
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
                .filter { $0 != .notDetermined }
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

}

