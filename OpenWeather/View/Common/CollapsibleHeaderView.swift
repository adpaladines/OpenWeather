//
//  CollapsibleHeaderView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct CollapsibleHeaderView: View {
    @EnvironmentObject var themeColor: ThemeColor
    
    var title: String
    var image: Image
    var height: CGFloat = 64
    
    @Binding var isClosed: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isClosed.toggle()
            }
        }label: {
            HStack(alignment: .center, spacing: 16) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeColor.imageBackground)
                    .overlay {
                        image
                            .resizable()
                            .background(themeColor.imageBackground)
                            .foregroundColor(themeColor.text)
                            .frame(width: 16, height: 16, alignment: .center)
                    }
                    .frame(width: 28, height: 28, alignment: .center)
                    .padding(.leading)
                Text(title)
                    .fontWeight(.medium)
                    .foregroundColor(themeColor.text)
                Spacer()
                Image(systemName: isClosed ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor(themeColor.button)
            }
            .padding(.trailing)
        }
        .frame(height: height)
    }
}

struct CollapsibleHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CollapsibleHeaderView(title: "Today info".localized(), image: Image(systemName: "info.circle"), isClosed: .constant(false))
            .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
    }
}
