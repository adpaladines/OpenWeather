//
//  MainCitySearchBarView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct MainCitySearchBarView: View {
    @EnvironmentObject var themeColor: ThemeColor

    var cityName: String?
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text(cityName ?? "No city found")
                .foregroundColor(themeColor.text)
            Spacer()
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeColor.text)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MainCitySearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainCitySearchBarView(cityName: "Paris")
            .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
    }
}

