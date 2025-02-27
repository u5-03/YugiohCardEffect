//
//  YugiohCardEffectView.swift
//  YugiohCardEffect
//
//  Created by yugo.sugiyama on 2025/02/23.
//

import SwiftUI

public struct YugiohCardEffectView: View {

    @State private var controller: YugiohCardEffectController
    private let lineWidth: CGFloat = 10
    private let cardWidthRatio: CGFloat = 0.6
    private let cardHeightRatio: CGFloat = CardView.cardSize.height / CardView.cardSize.width

    public init(controller: YugiohCardEffectController) {
        self.controller = controller
    }

    public var body: some View {
        GeometryReader { proxy in
            let cardWidth = proxy.size.width * cardWidthRatio
            ZStack(alignment: .center) {
                frameView(parentSize: proxy.size)
                LineEffectColorView()
                    .mask {
                        LineEffectView(
                            topLineConfigs: controller.topLineConfigs,
                            leadingLineConfigs: controller.leadingLineConfigs,
                            trailingLineConfigs: controller.trailingLineConfigs,
                            cardSize: .init(
                                width: cardWidth,
                                height: cardWidth * cardHeightRatio
                            ),
                            fromAnimationProgress: $controller.fromAnimationProgress,
                            toAnimationProgress: $controller.toAnimationProgress
                        )
                    }
                    .frame(width: proxy.size.width)
                topEdgeView(parentSize: proxy.size)
                    if let cardModel = controller.selectedCardModel {
                        CardView(card: cardModel)
                            .frame(width: cardWidth, alignment: .center)
                            .rotation3DEffect(controller.cardAngle, axis: (1 ,0, 0), anchor: .bottom, perspective: 0.6)
                    }
                VStack {
                    Spacer()
                    Button {
                        Task {
                            await controller.startEffectAnimation()
                        }
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

#Preview {
    YugiohCardEffectView(controller: .init(cardModels: [.sample, .sample2]))
}
