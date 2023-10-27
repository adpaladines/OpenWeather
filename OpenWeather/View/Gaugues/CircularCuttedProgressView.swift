//
//  CircularCuttedProgressView.swift
//  OpenWeather
//
//  Created by andres paladines on 10/26/23.
//

import SwiftUI

enum CircularCuttedProgressSize {
    case small
    case medium
    case large
}

extension CircularCuttedProgressSize {
    
    var fontSize: CGFloat {
        let newValue: CGFloat
        switch self {
        case .small:
            newValue = 8
        case .medium:
            newValue = 12
        case .large:
            newValue = 14
        }
        return newValue
    }
    
}

enum LegendPosition {
    case center
    case bottom
}

struct CircularCuttedConfiguration: Hashable, Identifiable {
    let progressValue: Double
    let color: Color
    let size: CircularCuttedProgressSize
    let legendPosition: LegendPosition
    let legend: String
    let legendColor: Color
    
    var id: String {
        legend
    }
}

struct CircularCuttedProgressView: View {
    
    let config: CircularCuttedConfiguration

    init(config: CircularCuttedConfiguration) {
        self.config = config
    }
    
    private var frameSize: CGSize {
        let newSize: CGSize
        switch config.size {
        case .small:
            newSize = CGSize(width: 64, height: 64)
        case .medium:
            newSize = CGSize(width: 96, height: 96)
        case .large:
            newSize = CGSize(width: 128, height: 128)
        }
        return newSize
    }
    
    private var lineWidth: CGFloat {
        let newSize: CGFloat
        switch config.size {
        case .small:
            newSize = CGFloat(8)
        case .medium:
            newSize = CGFloat(12)
        case .large:
            newSize = CGFloat(16)
        }
        return newSize
    }
    
    private var internalValue: Double {
        config.progressValue * 0.66
    }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.66)
                .stroke(
                    config.color.opacity(0.4),
                    style:
                        StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                )
                .padding(.all, 8)
                .rotationEffect(Angle(degrees: 150))
            
            Circle()
                .trim(from: 0, to: internalValue)
                .stroke(
                    config.color,
                    style:
                        StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                )
                .padding(.all, 8)
                .rotationEffect(Angle(degrees: 150))
                .transition(.opacity)
                .animation(.easeOut, value: internalValue)

            GeometryReader { geometry in
                HStack{}
                .frame(width: geometry.size.width/1.5, height: geometry.size.height)
                .overlay(putText(config.legend, width: geometry.size.width/1.7,and: config.legendColor), alignment: config.legendPosition == .center ? .center : .bottom)
                .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
                
                
            }
        }
        .frame(width: frameSize.width, height: frameSize.height, alignment: .center)
        .padding(.top)
    }
    
    @ViewBuilder
    func putText(_ string: String, width: CGFloat, and color: Color) -> some View {
        Text(string)
            .font(Font.system(size: config.size.fontSize,weight: .bold))
            .frame(width: width - 6, height: 36, alignment: .center)
            .multilineTextAlignment(.center)
            .foregroundStyle(color)
    }
}

struct CircularCuttedProgressView_Previews: PreviewProvider {
    
    static var previews: some View {
        CircularCuttedProgressView(
            config:
                CircularCuttedConfiguration(
                    progressValue: 0.4,
                    color: .yellow,
                    size: .large,
                    legendPosition: .center,
                    legend: "PHP 7.9",
                    legendColor: .black
                )
        )
    }
}



