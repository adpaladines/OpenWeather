//
//  MainCitySearchBarView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct MainCitySearchBarView: View {
    
    @EnvironmentObject var themeColor: ThemeColor

    @Binding var selectedCityName: String
    
    var cityName: String?
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text(cityName ?? "No city found")
                .foregroundColor(themeColor.text)
            Spacer()
            NavigationLink(
                destination: CitySearchScreen(
                    selectedCityName: $selectedCityName
                )
            ) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(themeColor.text)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct MainCitySearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainCitySearchBarView(
            selectedCityName: .constant("Deerfield Beach"),
            cityName: "Deerfield Beach"
        )
            .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
    }
}

