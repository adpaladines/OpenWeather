//
//  MiniGaugeData.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct MiniGaugeData: Hashable, Identifiable {
    
    let title: String
    let progressValue: Double
    let color: Color
    let size: CircularCuttedProgressSize
    let legendPosition: LegendPosition
    let legend: String
    
    var id: String {
        legend
    }
}
