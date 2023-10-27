//
//  URLSession+Extensions.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

extension URLSession: URLSessionable {
    
    func getData(for urlRequest: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        try await self.data(for: urlRequest, delegate: delegate)
    }
        
}

