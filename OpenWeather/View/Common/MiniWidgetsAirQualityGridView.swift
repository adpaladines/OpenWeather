//
//  MiniWidgetsAirQualityGridView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct MiniWidgetsAirQualityGridView: View {
    @EnvironmentObject var themeColor: ThemeColor

    @Binding var isClosed: Bool
    
    var miniGauges: Array<MiniGaugeData>
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 90, maximum: 250))
            ],
            spacing: isClosed ? 0 : 24) {
                ForEach(miniGauges) { gauge in
                    VStack(alignment: .center, spacing: 0) {
                        Text(gauge.title)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(themeColor.text)
                        CircularCuttedProgressView(
                            config:
                                CircularCuttedConfiguration(
                                    progressValue: gauge.progressValue,
                                    color: gauge.color,
                                    size: gauge.size,
                                    legendPosition: gauge.legendPosition,
                                    legend: gauge.legend,
                                    legendColor: themeColor.text
                                )
                        )
                    }
                    
                    .frame(height: isClosed ? 0 : 110)
                    .frame(maxWidth: 196)
                    .padding(.horizontal)
                    .containerBackground(withColor: themeColor.containerBackground)
                }
//                .opacity(isClosed ? 0 : 0.5)
                .animation(.easeIn, value: isClosed)
        }
    }
}

struct MiniWidgetsAirQualityGridView_Previews: PreviewProvider {
    static var previews: some View {
        MiniWidgetsAirQualityGridView(
            isClosed: .constant(false),
            miniGauges: [
                MiniGaugeData(title: "Good".localized(), progressValue: 0.2, color: .gray, size: .small, legendPosition: .bottom, legend: "AQI"),
                
                MiniGaugeData(title: "Fair".localized(), progressValue: 0.4, color: .green, size: .small, legendPosition: .bottom, legend: "SO2"),
                
                MiniGaugeData(title: "Moderate".localized(), progressValue: 0.6, color: .yellow, size: .small, legendPosition: .bottom, legend: "NO2"),
                
                MiniGaugeData(title: "Poor".localized(), progressValue: 0.8, color: .orange, size: .small, legendPosition: .bottom, legend: "PM10"),
                
                MiniGaugeData(title: "Very Poor".localized(), progressValue: 1.0, color: .red, size: .small, legendPosition: .bottom, legend: "PM2.5")
            ]
        )
        .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
    }
}

