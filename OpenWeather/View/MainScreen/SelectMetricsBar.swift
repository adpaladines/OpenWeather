//
//  SelectMetricsBar.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct SelectMetricsBarView: View {
    @EnvironmentObject var themeColor: ThemeColor
    
    @AppStorage("currentMeasurementUnit") var currentMeasurementUnit: String = MeasurementUnit.standard.rawValue
    
//    @State var currMetrics: MeasurementUnit
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Spacer()
            Menu {
                Button {
                    currentMeasurementUnit = MeasurementUnit.metric.rawValue
//                    currMetrics = .metric
                }label: {
                    Text("Celcius")
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                }
                Button {
                    currentMeasurementUnit = MeasurementUnit.imperial.rawValue
//                    currMetrics = .imperial
                }label: {
                    Text("Fahrenheit")
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                }
                Button {
                    currentMeasurementUnit = MeasurementUnit.standard.rawValue
//                    currMetrics = .standard
                }label: {
                    Text("Kelvin")
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Change Units (current: "+currentMeasurementUnit+")")
                        .tint(themeColor.text)
                    ZStack {
//                        RoundedRectangle(cornerRadius: 12)
//                            .foregroundColor(Color(hex: "F1F1F1", alpha: 1.0))
                        Image(systemName: "chevron.down.circle")
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .center)
                            .padding([.all], 2)
                            .tint(themeColor.text)
                    }
                    .frame(width: 56, height: 56, alignment: Alignment.center)
                }
               
            }
            .menuStyle(.automatic)
            

            
        }
        .frame(maxWidth: .infinity)
    }
}

struct SelectMetricsBarView_Previews: PreviewProvider {
    static var previews: some View {
//        SelectMetricsBarView(currMetrics: .constant(MeasurementUnit.metric))
        SelectMetricsBarView()
            .environmentObject(ThemeColor(appTheme: AppTheme.light.rawValue))
    }
}
