//
//  GradientHolographicEffect.swift
//  YugiohCardEffect
//
//  Created by yugo.sugiyama on 2025/02/27.
//

import SwiftUI

// Ref: https://zenn.dev/ikeh1024/articles/682e52f514776f
extension View {
    func gradientHolographicEffect(locationRatioX: Double) -> some View {

        let gradientLocationCenter = min(max(locationRatioX, 0.11), 0.89)  // 0.11 ~ 0.89
        let gradient = Gradient(stops: [
            .init(
                color: .clear,
                location: 0
            ),
            .init(
                color: Color(red: 0, green: 231/255, blue: 1).opacity(0.9),
                location: gradientLocationCenter - 0.1
            ),
            .init(
                color: .blue.opacity(0.6),
                location: gradientLocationCenter
            ),
            .init(
                color: Color(red: 1, green: 0, blue: 231/255).opacity(0.4),
                location: gradientLocationCenter + 0.1
            ),
            .init(
                color: .clear,
                location: 1.0
            )
        ])

        return self
            .overlay() {
                GeometryReader { proxy in
                    let length = max(proxy.size.width, proxy.size.height) * 1.5
                    LinearGradient(
                        gradient: gradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .opacity(1.0)
                    .frame(width: length, height: length, alignment: .center)
                    .rotationEffect(Angle(degrees: 45), anchor: .top)
                    .blendMode(.overlay)
                }
            }
    }
}

#Preview {
    CardView(card: .sample2)
        .aspectRatio(CardView.cardAspectRatio, contentMode: .fit)
}
