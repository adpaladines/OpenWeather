//
//  AirPollutionData.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

struct AirPollutionData: Decodable {
    let coord: CoordinateData
    let list: [AirPollutionDataElement]
}

struct AirPollutionDataElement: Decodable {
    let dt: Int
    let main: AirPollutionDataMain
    let components: [String: Double]
}

extension AirPollutionDataElement {
    var co: Double? {
        self.components["co"]
    }
    var no: Double? {
        self.components["no"]
    }
    var no2: Double? {
        self.components["no2"]
    }
    var o3: Double? {
        self.components["o3"]
    }
    var so2: Double? {
        self.components["so2"]
    }
    var pm2_5: Double? {
        self.components["pm2_5"]
    }
    var pm10: Double? {
        self.components["pm10"]
    }
    var nh3: Double? {
        self.components["nh3"]
    }
}

struct AirPollutionDataMain: Decodable {
    let aqi: Int
}
