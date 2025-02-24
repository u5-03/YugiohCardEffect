//
//  LineEffectColorView.swift
//  YugiohCardEffect
//
//  Created by yugo.sugiyama on 2025/02/23.
//

import SwiftUI

struct LineEffectColorView: View {
    var colors: [Color] {
        let baseHue = Double.random(in: 0...1) // HSBのHを基準
        return [
            Color(hue: baseHue, saturation: 0.7, brightness: 0.8),
            Color(hue: baseHue + 0.1, saturation: 0.8, brightness: 0.9),
            Color(hue: baseHue - 0.1, saturation: 0.6, brightness: 0.7)
        ]
    }

    var body: some View {
        GeometryReader { proxy in
            RadialGradient(
                gradient: Gradient(
                    colors: colors + colors + colors + colors + colors + colors + colors + colors
                ),
                center: .center,
                startRadius: 0,
                endRadius: proxy.size.width
            )
            .blur(radius: 10)
        }
    }
}

#Preview {
    LineEffectColorView()
}
