//
//  Serviceable.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

protocol Serviceable {
    func getDataFromApi(requestable: Requestable) async throws -> Data
}
