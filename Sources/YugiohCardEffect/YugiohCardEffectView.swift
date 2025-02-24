//
//  YugiohCardEffectView.swift
//  YugiohCardEffect
//
//  Created by yugo.sugiyama on 2025/02/23.
//

import SwiftUI

struct YugiohCardEffectView: View {
    @State var fromAnimationProgress: CGFloat = -1
    @State var toAnimationProgress: CGFloat = 0
    @State var cardAngle: Angle = .degrees(-90)
    @State var topLineConfigs: [LineConfig] = []
    @State var leadingLineConfigs: [LineConfig] = []
    @State var trailingLineConfigs: [LineConfig] = []

    private let lineWidth: CGFloat = 10
    private let cardWidthRatio: CGFloat = 0.6
    private let cardHeightRatio: CGFloat = CardView.cardSize.height / CardView.cardSize.width

    var body: some View {
        GeometryReader { proxy in
            let cardWidth = proxy.size.width * cardWidthRatio
            ZStack(alignment: .center) {
                frameView(parentSize: proxy.size)
                LineEffectColorView()
                    .mask {
                        LineEffectView(
                            topLineConfigs: topLineConfigs,
                            leadingLineConfigs: leadingLineConfigs,
                            trailingLineConfigs: trailingLineConfigs,
                            cardSize: .init(
                                width: cardWidth,
                                height: cardWidth * cardHeightRatio
                            ),
                            fromAnimationProgress: $fromAnimationProgress,
                            toAnimationProgress: $toAnimationProgress
                        )
                    }
                    .frame(width: proxy.size.width)
                topEdgeView(parentSize: proxy.size)
                CardView(card: .sample)
                    .frame(width: cardWidth, alignment: .center)
                    .rotation3DEffect(cardAngle, axis: (1 ,0, 0), anchor: .bottom, perspective: 0.6)
                VStack {
                    Spacer()
                    Button {
                        startEffectAnimation()
                    } label: {
                        Text("Summon")
                            .font(.system(size: 32, weight: .medium))
                            .padding(.horizontal, 100)
                    }
                    .buttonStyle(.borderedProminent)
                    .clipShape(Capsule())
                }
                .padding(.bottom, 20)
                .safeAreaPadding(.bottom)
            }
            .background(Color(hex: "314446"))
            .frame(width: proxy.size.width)
        }
        .ignoresSafeArea()
    }
}

private extension YugiohCardEffectView {
    func frameView(parentSize: CGSize) -> some View {
        return ZStack(alignment: .center) {
            Rectangle()
                .foregroundStyle(.black)
                .frame(width: lineWidth, height: parentSize.height)
                .offset(x: -parentSize.width * 0.4)
            Rectangle()
                .foregroundStyle(.black)
                .frame(width: lineWidth, height: parentSize.height)
                .offset(x: parentSize.width * 0.4)
            Rectangle()
                .foregroundStyle(.black)
                .frame(width: parentSize.width, height: lineWidth)
                .offset(y: parentSize.width * cardWidthRatio * cardHeightRatio / 2 + parentSize.height * 0.1)
            Rectangle()
                .foregroundStyle(.black)
                .frame(width: parentSize.width, height: lineWidth)
                .offset(y: -(parentSize.width * cardWidthRatio * cardHeightRatio / 2 + parentSize.height * 0.1))
        }
        .frame(width: parentSize.width, height: parentSize.height)
    }

    func topEdgeView(parentSize: CGSize) -> some View{
        return VStack {
            Color.red.brightness(0.2)
                .frame(height: parentSize.height / 2 - (parentSize.width * cardWidthRatio * cardHeightRatio / 2 + parentSize.height * 0.1) + lineWidth / 2, alignment: .top)
            Spacer()
        }
    }
}

private extension YugiohCardEffectView {
    func startEffectAnimation() {
        topLineConfigs = LineConfig.randomConfigss(count: 7, isTop: true)
        leadingLineConfigs = LineConfig.randomConfigss(count: 10)
        trailingLineConfigs = LineConfig.randomConfigss(count: 10)
        cardAngle = .degrees(-90)

        fromAnimationProgress = -1
        toAnimationProgress = 0
        withAnimation(.linear(duration: 0.5)) {
            cardAngle = .degrees(0)
        } completion: {
            withAnimation(.linear(duration: 0.3)) {
                fromAnimationProgress = 1
                toAnimationProgress = 2
            }
        }
    }
}

#Preview {
    YugiohCardEffectView()
}
