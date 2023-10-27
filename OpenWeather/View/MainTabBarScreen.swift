//
//  MainTabBarScreen.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct MainTabBarScreen: View {
    
    @EnvironmentObject var themeColor: ThemeColor
    @EnvironmentObject var currentLanguage: CurrentLanguage
    
    var body: some View {
        TabView() {
//            MainLocationScreen(
//                viewModel: MainLocationViewModel(
//                    repository: WeatherFakeRepository(
//                        isStubbingData: true
//                    )
//                ), isForTesting: true
//            )
            MainLocationScreen(
                viewModel: MainLocationViewModel(
                    repository: WeatherRepository()
                )
            )
            .tabItem {
                TabViewItem(type: .home)
            }
            SettingsScreen()
                .tabItem {
                    TabViewItem(type: .settings)
                }
        }
        .accentColor(themeColor.button)
        .preferredColorScheme(themeColor.colorScheme)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            // Use this appearance when scrolling behind the TabView:
            UITabBar.appearance().standardAppearance = appearance
            // Use this appearance when scrolled all the way up:
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabBarScreen()
        .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
        .environmentObject(CurrentLanguage(code: "en"))
}
