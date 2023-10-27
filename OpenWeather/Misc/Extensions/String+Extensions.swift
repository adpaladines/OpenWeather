//
//  String+Extensions.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import Foundation
import SwiftUI

extension String {
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    func convertDateToRequiredFormat() -> String {
        ""
    }
    
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle(), value: "", comment: "")
    }
    
    func localizeWithFormat(arguments: CVarArg...) -> String{
        return String(format: self.localized(), arguments: arguments)
    }
    
}
