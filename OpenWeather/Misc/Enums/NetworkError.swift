//
//  NetworkError.swift
//  OpenWeather
//
//  Created by andres paladines on 10/25/23.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case request
    case timeout
    case response(Int)
    case dataNotFound
    case parsingValue
    case none
    case network(String)
}

extension NetworkError: LocalizedError, Equatable {
    
    var errorDescription: String? {
        let localizedString: String
        let reflectionString = String(reflecting: self)
        switch self {
        case .invalidUrl:
            localizedString = NSLocalizedString("Malformed URL.".localized(), comment: reflectionString)
        case .dataNotFound:
            localizedString = NSLocalizedString("Resource not found.".localized(), comment: reflectionString)
        case .parsingValue:
            localizedString = NSLocalizedString("Response cannot be pased.".localized(), comment: reflectionString)
        case .response(let code):
            localizedString = NSLocalizedString("Invalid status \(code) code from response.".localized(), comment: reflectionString)
        case .timeout:
            localizedString = NSLocalizedString("No service response (timeout).".localized(), comment: reflectionString)
        case .request:
            localizedString = NSLocalizedString("Invalid request.".localized(), comment: reflectionString)
        case .none:
            localizedString = NSLocalizedString("No errors detected".localized(), comment: reflectionString)
        case .network(let netError):
            localizedString = NSLocalizedString("Network error: \(netError)".localized(), comment: reflectionString)
        }
        return localizedString
    }
    
    mutating func setCustomErrorStatus(with error: Error?) {
        guard let error = error else {
            self = NetworkError.none
            return
        }
        switch error {
        case is DecodingError:
            self = NetworkError.parsingValue
        case is URLError:
            self = .invalidUrl
        case NetworkError.dataNotFound:
            self = NetworkError.dataNotFound
        case NetworkError.response:
            self = NetworkError.response(error._code)
        case is CancellationError:
            self = .dataNotFound
        default:
            self = .dataNotFound
        }
    }
}

