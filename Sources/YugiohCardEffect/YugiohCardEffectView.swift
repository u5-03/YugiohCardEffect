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
    private let topEdgeRatio: CGFloat = 0.1
    private let cardHorizontalPaddingRatio: CGFloat = 0.1
    private let cardVerticalPaddingRatio: CGFloat = 0.3
    private let cardHeightRatio: CGFloat = CardView.cardSize.height / CardView.cardSize.width

    public init(controller: YugiohCardEffectController) {
        self.controller = controller
    }

    public var body: some View {
        GeometryReader { proxy in
            let cardAreaHeight = proxy.size.height * (0.5 - cardVerticalPaddingRatio) * 2
            let cardAreaWidth = proxy.size.width * (0.5 - cardHorizontalPaddingRatio) * 2
            let cardWidth = min(cardAreaHeight, cardAreaWidth)
            * 0.9
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
                            .frame(width: cardWidth, height: cardWidth * CardView.cardAspectVerticalRatio, alignment: .center)
                            .rotation3DEffect(controller.cardAngle, axis: (1 ,0, 0), anchor: .bottom, perspective: 0.6)
                            .id(cardModel.id)
                    }
                VStack(alignment: .trailing) {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            Task {
                                await controller.startEffectAnimation()
                            }
                        } label: {
                            Text("召喚")
                                .font(.system(size: 32, weight: .medium))
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .clipShape(Circle())
                    }
                }
                .padding(.bottom, 20)
                .safeAreaPadding([.bottom, .trailing])
            }
            .background(Color(hex: "314446"))
            .frame(width: proxy.size.width)
        }
        .ignoresSafeArea()
    }
}

private extension YugiohCardEffectView {
    func frameView(parentSize: CGSize) -> some View {
        let maxLength = max(parentSize.width, parentSize.height)
        let height = parentSize.height
        let width = parentSize.width
        return ZStack(alignment: .center) {
            Rectangle()
                .foregroundStyle(.black)
                .frame(width: lineWidth, height: maxLength)
                .offset(x: -width * (0.5 - cardHorizontalPaddingRatio))
            Rectangle()
                .foregroundStyle(.black)
                .frame(width: lineWidth, height: maxLength)
                .offset(x: width * (0.5 - cardHorizontalPaddingRatio))
            Rectangle()
                .foregroundStyle(.black)
                .frame(width: maxLength, height: lineWidth)
                .offset(y: height * cardVerticalPaddingRatio)
            Rectangle()
                .foregroundStyle(.black)
                .frame(width: maxLength, height: lineWidth)
                .offset(y: -(height * cardVerticalPaddingRatio))
        }
        .frame(width: parentSize.width, height: parentSize.height)
    }

    func topEdgeView(parentSize: CGSize) -> some View{
        let minLength = min(parentSize.width, parentSize.height)
        return VStack {
            Color.red.brightness(0.2)
                .frame(height: minLength * topEdgeRatio + lineWidth / 2, alignment: .top)
            Spacer()
        }
    }
}

#Preview {
    YugiohCardEffectView(controller: .init(cardModels: [.sample, .sample2]))
}
