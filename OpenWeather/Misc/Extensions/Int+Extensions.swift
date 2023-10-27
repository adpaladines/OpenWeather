//
//  Int+Extensions.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

extension Int {
    var timestampToDayString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: date)
    }
    
    var timestampToDayStringShort: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        return dateFormatter.string(from: date)
    }
    
    var timestampToHourString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        
        return dateFormatter.string(from: date)
    }
    
    var timestampToHourMinuteString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:m a"
        
        return dateFormatter.string(from: date)
    }
    
}
