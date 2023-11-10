//
//  MainTabBarScreen.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct MainTabBarScreen: View {
    
    @AppStorage("app_lang") var appLang: String = "en"

    @EnvironmentObject var themeColor: ThemeColor
    
    // We only need to change the value to refresh the item elements.
    @State private var homeItemText = TabViewItemType.home.text
    @State private var settingsItemText = TabViewItemType.settings.text

    var body: some View {
        TabView() {
            NavigationView {
//            MainLocationScreen(
//                viewModel: MainLocationViewModel(
//                    repository: WeatherFakeRepository(
//                        isStubbingData: true
//                    )
//                ),
//                selectedCityName: "Deerfield Beach",
//                isForTesting: true
//            )
                MainLocationScreen(
                    viewModel: MainLocationViewModel(
                        repository: WeatherRepository()
                    ), 
                    selectedCityName: "Deerfield Beach"
                )
            }
            .tabItem {
                TabViewItem(type: .home, title: homeItemText)
            }
            
            SettingsScreen()
                .tabItem {
                    TabViewItem(type: .settings, title: settingsItemText)
                }
        }
        .navigationViewStyle(.stack)
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
        .onChange(of: appLang) { newValue in
            homeItemText = TabViewItemType.home.text
            settingsItemText = TabViewItemType.settings.text
        }
    }
}

#Preview {
    MainTabBarScreen()
        .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
        .environmentObject(CurrentLanguage(code: "en"))
}
