//
//  ApiKeyCellView.swift
//  OpenWeather
//
//  Created by andres paladines on 11/17/23.
//

import SwiftUI

struct ApiKeyCellView: View {
    
    @EnvironmentObject var themeColor: ThemeColor
    var isSelected: Bool
    var title: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(themeColor.imageBackground)
                .overlay {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "checkmark.circle")
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(themeColor.button)
                }
                .frame(width: 28, height: 28, alignment: .center)
                .padding(.leading)
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(themeColor.text)
            Spacer()
        }
        .padding(.trailing)
    }
    
}

#Preview {
    ApiKeyCellView(isSelected: true, title: "My Api Key")
}
