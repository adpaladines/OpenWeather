//
//  URLResponse+Extensions.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation

extension URLResponse: URLResponseable {
    
    func isValidUrlResponse() -> Bool {
        guard let response = self as? HTTPURLResponse else {
            return false
        }
        let code = response.statusCode
        switch code {
        case 200..<300:
            return true
        case 300..<400:
            return true
        case 400..<500:
            return false
        case 500..<600:
            return false
        default:
            return false
        }
    }
    
    var httpStatusCode: Int {
        guard let response = self as? HTTPURLResponse else {
            return 0
        }
        return response.statusCode
    }
    
}
