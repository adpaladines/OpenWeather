//
//  OpenWeatherApp.swift
//  OpenWeather
//
//  Created by andres paladines on 10/25/23.
//

import SwiftUI

class CurrentLanguage: ObservableObject {
//    AvailableLanguage
    private var languageCode: String
    
    init(code: String) {
        self.languageCode = code
    }
}

//0-> It works only as a listener to refresh the app every time we change the language.

@main
struct OpenWeatherForecastApp: App {
    
    @Environment(\.colorSchemeContrast) var colorSchemeContrast

    @AppStorage("app_lang") var appLang: String = "en"
    @AppStorage("appTheme") var appTheme = AppTheme.dark.rawValue
    @AppStorage("appThemeUserDefined") var appThemeUserDefined = false
    @AppStorage("appIconSelected") var appIconSelected: String = AppIconType.light.rawValue

    var body: some Scene {
        WindowGroup {
            MainTabBarScreen()
                .environmentObject(ThemeColor(appTheme: appTheme))
                .environmentObject(CurrentLanguage(code: appLang)) //0->
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
