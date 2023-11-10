//
//  TabViewItem.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct TabViewItem: View {

    var type: TabViewItemType
    var title: String
    
    var body: some View {
        VStack {
            type.image.renderingMode(.template)
            Text(type.text)
//            Text(title)
        }
    }
}

#Preview {
    TabViewItem(type: .home, title: TabViewItemType.home.text)
}
