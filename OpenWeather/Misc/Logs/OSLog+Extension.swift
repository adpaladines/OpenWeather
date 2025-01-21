//
//  OSLog+Extension.swift
//  OpenWeather
//
//  Created by andres paladines on 12/27/23.
//

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
    
    /// Logs related with service events.
    static let service = Logger(subsystem: subsystem, category: "service")
    
    /// Logs related with file events.
    static let file = Logger(subsystem: subsystem, category: "file")
    
    /// Logs related with storage events.
    static let storage = Logger(subsystem: subsystem, category: "storage")
    
}
