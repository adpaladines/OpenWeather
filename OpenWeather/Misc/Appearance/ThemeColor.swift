//
//  ThemeColor.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

enum AppTheme: String, CaseIterable {
    case light
    case dark
//    case monoLight
//    case monoDark
}

extension AppTheme {
    
    var name: String {
        var value: String
        switch self {
        case .light:
            value = "Light".localized()
        case .dark:
            value = "Dark".localized()
//        case .monoLight:
//            value = "Mono Light".localized()
//        case .monoDark:
//            value = "Mono Dark".localized()
        }
        return value
    }
}

class ThemeColor: ObservableObject {
        
    private var appThemeEnum: AppTheme
    
    public var isLight: Bool {
        switch appThemeEnum {
        case .light://, .monoLight:
            return true
        case .dark://, .monoDark:
            return false
        }
    }
    
    public var colorScheme: ColorScheme {
        guard isLight else {
            return .dark
        }
        return .light
    }
    
    public var colorThemeName: String? {
        didSet {
            if let colorThemeName_ = colorThemeName, let newTheme = AppTheme(rawValue: colorThemeName_) {
                appThemeEnum = newTheme
            }
        }
    }
    
    init(appTheme: String) {
        guard let newTheme = AppTheme(rawValue: appTheme) else {
            self.appThemeEnum = .dark
            return
        }
        self.appThemeEnum = newTheme
    }
    
    var button: Color {
        switch appThemeEnum {
        case .light://, .monoLight:
            return Color(hex: "8A20D5")
        case .dark:
            return Color(hex: "BD92DD")
//        case .monoDark:
//            return Color(hex: "BD92DD")
        }
    }
    
    var text: Color {
        switch appThemeEnum {
        case .light://, .monoLight:
            return .black
        case .dark://, .monoDark:
            return .white
        }
    }
    
    var imageBackground: Color {
        switch appThemeEnum {
        case .light://, .monoLight:
            return .white
        case .dark://, .monoDark:
            return .black.opacity(0.7)
        }
    }
    
    var containerBackground: Color {
        let value: Color
        switch appThemeEnum {
        case .light://, .monoLight:
            value = Color(hex: "EBDEFF")
        case .dark:
            value = Color(hex: "443A4B")
//        case .monoDark:
//            value = Color(hex: "241B2C")
        }
        return value
    }
    
    var screenBackground: Color {
        let value: Color
        switch appThemeEnum {
        case .light://, .monoLight:
            value = Color(hex: "F7ECFF")
        case .dark:
            value = Color(hex: "140A1B")
//        case .monoDark:
//            value = Color(hex: "241B2C")
        }
        return value
    }
        
    var tabBarItemColor: Color {
        guard isLight else {
            return Color(hex: "")
        }
        return Color(hex: "")
    }
    
    var tabBarItemSelectedColor: Color {
        guard isLight else {
            return Color(hex: "")
        }
        return Color(hex: "")
    }
    
    var warning: Color {
        guard isLight else {
            return Color(hex: "FEE445")
        }
        return Color(hex: "CAA100")
    }
    
    var gray: Color {
        guard isLight else {
            return Color(hex: "8F8F94")
        }
        return Color(hex: "828287")
    }
    
    var error: Color {
        guard isLight else {
            return Color(hex: "FF4E43")
        }
        return Color(hex: "FB3B30")
    }
    
}
