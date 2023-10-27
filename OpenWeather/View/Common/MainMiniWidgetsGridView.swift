//
//  MainMiniWidgetsGridView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct MainMiniWidgetsGridView: View {
    @EnvironmentObject var themeColor: ThemeColor

    @Binding var isClosed: Bool
    
    var miniWidgets: Array<MiniWidgetData>
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 164, maximum: 196))
            ],
            spacing: isClosed ? 0 : 24) {
                ForEach(miniWidgets) { widget in
                    HStack(alignment: .center, spacing: 0) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(themeColor.imageBackground)
                            .overlay {
                                Image(systemName: widget.systemIcon)
                                    .resizable()
                                    .background(themeColor.imageBackground)
                                    .foregroundColor(themeColor.text)
                                    .frame(width: 24, height: 24, alignment: .center)
                            }
                            .frame(width: 40, height: 40, alignment: .center)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text(widget.title)
                                .font(.callout)
                                .fontWeight(.medium)
                                .padding(.bottom, 2)
                            HStack {
                                Text(widget.value)
                                    .font(.footnote)
                                    .fontWeight(.medium)
                            }
                            HStack {
                                Spacer()
                                Text(widget.caption)
                                    .font(.caption)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.trailing)
                    }
                    .frame(height: isClosed ? 0 : 96)
                    .frame(maxWidth: 196)
                    .containerBackground(withColor: themeColor.containerBackground)
                }
                .animation(.easeIn, value: isClosed)
        }
    }
}

struct MainMiniWidgetsGridView_Previews: PreviewProvider {
    static var previews: some View {
        MainMiniWidgetsGridView(isClosed: .constant(false), miniWidgets: [MiniWidgetData(title: "AQI", systemIcon: "wind", value: "200m/s", caption: "strong winds")])
            .environmentObject(ThemeColor(appTheme: AppTheme.dark.rawValue))
    }
}

