//
//  View+Extensions.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

extension View {
    
    func containerBackground(withColor: Color) -> some View {
        self
        .frame(maxWidth: .infinity)
        .background(withColor)
        .cornerRadius(12)
    }
    
    func containerHeaderBackground() -> some View {
        self
        .frame(maxWidth: .infinity)
        .background(Color(hex: "EBDEFF"))
        .cornerRadius(12)
    }

    var viewController: UIViewController {
        let vc = UIHostingController(rootView: self)
        vc.view.frame = UIScreen.main.bounds
        return vc
    }
    
    func toVC() -> UIViewController {
        let vc = UIHostingController(rootView: self)
        vc.view.frame = UIScreen.main.bounds
        return vc
    }
    
    func makeSecureTextField() -> some View {
        return ZStack(alignment: .center) {
            self
            GeometryReader() { geometry in
                SecureField("", text: .constant(""))
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // You can adjust the size as needed
                    .background(Color.clear) // Customize the background color
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1) // Customize the border
                    )
            }
        }
    }
}
