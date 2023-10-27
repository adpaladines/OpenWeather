//
//  MainTemperatureBarView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct MainTemperatureBarView: View {
    
    @EnvironmentObject var themeColor: ThemeColor
    
    var temperature: Double?
    var feelsLike: Double?
    var iconUrl: URL?
    
    @State var rightToLeftAnimation = Animation.linear(duration: 4)
    @State var alpha = 1.0
    @State var offset = UIScreen.main.bounds.width - 45
    
    var body: some View {
        HStack {
            Text((temperature?.description ?? "N/A") + "°")
                .foregroundColor(themeColor.text)
                .font(SwiftUI.Font.system(size: 42))
                .fontWeight(.medium)
                
            VStack {
                Spacer()
                Text("Feels like".localized() + " \(feelsLike?.description ?? "N/A")")
                    .foregroundColor(themeColor.text)
                    .font(.caption)
                    .fontWeight(.bold)
                    .offset(CGSize(width: -12, height: -8))
            }
            .frame(height: 56)
            
            Spacer()
            
            AsyncImage(url: iconUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .shadow(radius: 2)
                    .background(themeColor.imageBackground)
                    .cornerRadius(10)
                    .transition(.scale)
                    .animation(rightToLeftAnimation, value: alpha)
                    .offset(x: 0)
                    .onAppear {
                        alpha = 0.4
                        offset = -45
                    }
            } placeholder: {
                ZStack {
                    Image(systemName: "photo")
                    ProgressView()
                        .frame(width: 64, height: 64)
                }
                .background(themeColor.imageBackground)
                .cornerRadius(10)
            }
        }
    }
}

struct MainTemperatureBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTemperatureBarView(
            temperature: 25,
            feelsLike: 22,
            iconUrl: URL(string: "https://openweathermap.org/img/wn/10d@2x.png")
        )
        .environmentObject(ThemeColor(appTheme: AppTheme.light.rawValue))
    }
}
