//
//  TabViewItem.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

enum TabViewItemType: String {
    case login  = "login"
    case home   = "home"
    case search = "search"
    case settings = "settings"
    
    var image: Image {
        switch self {
        case .login:  return Image(systemName: "login")
        case .home:   return Image(systemName: "house")
        case .search: return Image(systemName: "search")
        case .settings: return Image(systemName: "gearshape")
        }
    }

    var text: Text {
        Text(self.rawValue.localized())
    }
}
