//
//  MiniWidgetData.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

struct MiniWidgetData: Hashable, Identifiable {
    
    let title: String
    let systemIcon: String
    let value: String
    let caption: String
    
    var id: String {
        title
    }
    
}
