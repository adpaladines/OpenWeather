//
//  TabViewItem.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

enum TabViewItemType {
    case login
    case home
    case search
    case settings
    
    var image: Image {
        switch self {
        case .login:  return Image(systemName: "login")
        case .home:   return Image(systemName: "house")
        case .search: return Image(systemName: "search")
        case .settings: return Image(systemName: "gearshape")
        }
    }

    var text: String {
        let newVal: String
        switch self {
        case .login:
            newVal = "login".localized()
        case .home:
            newVal = "home".localized()
        case .search:
            newVal = "search".localized()
        case .settings:
            newVal = "settings".localized()
        }
        return newVal
    }
}
