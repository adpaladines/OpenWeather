//
//  URLSessionable.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

protocol URLSessionable {
    
    func getData(for urlRequest: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
    
    
}
