//
//  CurrentWeatherRequest.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

struct CurrentWeatherRequest: Requestable {
    
    var apiVersion: ApiVersion
    
    var params: [String : String] = [:]
    var path: String
    
    var baseURL: String {
        return UrlEndpoints.shared.baseWeatherApi
    }
    
    var type: HttpRequestType {
        .get
    }
    
    mutating func set(lat: String, lon: String, metrics: MeasurementUnit? = nil) {
        var myparams =
        [
            "lat": lat,
            "lon": lon,
            "appid": UrlEndpoints.shared.apiKey
        ]
        
        guard let metrics_ = metrics else {
            self.params = myparams
            return
        }
        
        myparams["units"] = metrics_.rawValue
        self.params = myparams
    }
    
}
