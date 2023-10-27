//
//  Services.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

class Services {
    var urlSession: URLSessionable
    
    init(urlSession: URLSessionable = URLSession.shared) {
        self.urlSession = urlSession
    }

}

extension Services: Serviceable {
    
    func getDataFromApi(requestable: Requestable) async throws -> Data {
        do {
            guard let request = requestable.createURLRequest() else {
                throw NetworkError.invalidUrl
            }
            let (data, response) = try await urlSession.getData(for: request, delegate: nil)
            guard response.isValidUrlResponse() else {
                print(requestable.path)
                throw NetworkError.response(response.httpStatusCode)
            }
            return data
        } catch {
            print(error.localizedDescription)
            throw NetworkError.dataNotFound
        }
    }
        
}
