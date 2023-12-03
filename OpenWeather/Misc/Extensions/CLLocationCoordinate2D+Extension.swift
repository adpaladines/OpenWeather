//
//  CLLocationCoordinate2D+Extension.swift
//  OpenWeather
//
//  Created by andres paladines on 11/29/23.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    
    static public func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.latitude == right.latitude && left.longitude == right.longitude
    }
    
}
