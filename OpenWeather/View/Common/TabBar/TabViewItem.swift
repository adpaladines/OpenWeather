//
//  TabViewItem.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

struct TabViewItem: View {

    var type: TabViewItemType

    var body: some View {
        VStack {
            type.image.renderingMode(.template)
            type.text
        }
    }
}

#Preview {
    TabViewItem(type: .home)
}
