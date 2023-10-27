//
//  FiveDaysForecastbarView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct FiveDaysForecastbarView: View {
    @EnvironmentObject var themeColor: ThemeColor

    @StateObject var viewModel: MainLocationViewModel
    @Binding var isClosed: Bool
    @State var rotationAmount = 45.0
    
    var body: some View {
        VStack(spacing: 0) {
            CollapsibleHeaderView(title: "Hourly forecast (5 days)".localized(), image: Image(systemName: "clock"), height: 44, isClosed: $isClosed)
                .padding(.vertical, 10)
            HStack {
                if let forecastlist = viewModel.fiveForecastData?.list {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem.init(.flexible())]) {
                            ForEach(forecastlist) { day in
                                VStack {
                                    Text(day.dt.timestampToDayStringShort)
                                        .foregroundColor(themeColor.text)
                                        .padding(0)
                                    AsyncImage(url: URL(string: viewModel.getImageUrlBy(id: day.weather.first?.icon) ?? "")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 36, height: 36)
                                            .shadow(radius: 2)
                                            .padding(0)
                                            .rotation3DEffect(Angle(degrees: rotationAmount), axis: (x: 0, y: 1, z: 0))
                                            .onAppear {
                                                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1, initialVelocity: 0.8)) {
                                                    rotationAmount = 360
                                                }
                                            }
                                            
                                            
                                    } placeholder: {
                                        ZStack {
                                            Image(systemName: "photo")
                                            ProgressView()
                                        }
                                        .frame(width: 36, height: 36)
                                        .padding(0)
                                    }
                                    Text(day.main.temp.description)
                                        .padding(0)
                                }
                                .padding(.horizontal, 8)
                            }
                        }
                        .frame(height: isClosed ? 0 : 96)
                    }
                    
                }else {
                    Text("No data loaded.")
                        .foregroundColor(themeColor.text)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, isClosed ? 0 : nil)
        }
    }
}

struct FiveDaysForecastbarView_Previews: PreviewProvider {
    static var previews: some View {
        FiveDaysForecastbarView(viewModel: MainLocationViewModel(repository: WeatherRepository()), isClosed: .constant(false))
            .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
    }
}
