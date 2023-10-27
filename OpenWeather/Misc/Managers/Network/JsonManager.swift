//
//  JsonManager.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

class JsonManager: Serviceable {
    
    func getDataFromApi(requestable: Requestable) async throws -> Data {
        guard let request = requestable.createURLRequest(isFake: true) else {
            throw NetworkError.invalidUrl
        }
        let bundle = Bundle(for: JsonManager.self)
        guard let url = bundle.url(forResource: request.url!.absoluteString, withExtension: "json") else {
            throw NetworkError.invalidUrl
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        }catch {
            print(error.localizedDescription)
            throw error
        }
    }
        
}
