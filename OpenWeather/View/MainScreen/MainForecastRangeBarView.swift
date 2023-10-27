//
//  MainForecastRangeBarView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct MainForecastRangeBarView: View {
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Button {
                
            }label: {
                Text("Today")
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.white)
                    .cornerRadius(10)
            }
            .foregroundColor(.black)
            
            Button {
                
            }label: {
                Text("Tomorrow")
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.white)
                    .cornerRadius(10)
            }
            .foregroundColor(.black)
            
            Button {
                
            }label: {
                Text("10 days")
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.white)
                    .cornerRadius(10)
            }
            .foregroundColor(.black)
            
        }
    }
}

struct MainForecastRangeBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainForecastRangeBarView()
    }
}
