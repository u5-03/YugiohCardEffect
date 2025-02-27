//
//  CardView.swift
//  YugiohCardEffect
//
//  Created by yugo.sugiyama on 2025/02/22.
//

import SwiftUI

public struct CardView: View {
    public let card: CardModel
    static let cardAspectRatio: CGFloat = 59 / 86
    static let cardSize: CGSize = .init(width: 590, height: 860)
    private let cardImageVerticalRatio: CGFloat = 0.65 / 11.5

    public init(card: CardModel) {
        self.card = card
    }

    public var body: some View {
        GeometryReader { proxy in
            Group {
                ZStack {
                    Color(hex: "4D5E7C")
                    ZStack {
                        paperTextureView
                        cardContentView
                    }
                    .padding(10)
                }
            }
            .aspectRatio(CardView.cardAspectRatio, contentMode: .fit)
            .frame(width: CardView.cardSize.width, height: CardView.cardSize.height)
            .scaleEffect(scale(for: proxy.size), anchor: .center)
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

private extension CardView {
    var cardContentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardTitle
            HStack(spacing: 4) {
                Spacer()
                ForEach(
                    0..<card.starCount, id: \.self) { _ in
                    starView
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            HStack(spacing: 0) {
                Spacer()
                card.imageBackgroundColor
                    .aspectRatio(1, contentMode: .fill)
                    .border(Color(hex: "223B4B"), width: 4)
                    .overlay {
                        card.imageType.view
                            .aspectRatio(card.imageType.aspectRatio, contentMode: .fit)
                            .padding(30)
                    }
                    .padding(4)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 4)
            cardDescriptionView
            HStack {
                Text(card.id.uuidString)
                    .font(.system(size: 12))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }

    var cardTitle: some View {
        ZStack {
            // 背景（影用）
            Rectangle()
                .foregroundStyle(Color(hex: "8F794E").opacity(0.1))
                .frame(height: 60)
                .cornerRadius(4)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 8, y: 8) // 大きな影
            // 本体
            Rectangle()
                .foregroundStyle(Color(hex: "8F794E").opacity(0.5))
                .frame(height: 60)
                .cornerRadius(4)
                .shadow(color: Color.white.opacity(0.5), radius: 4, x: -4, y: -4) // 内側からの光
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 4, y: 4) // 外側の影
            HStack {
                Text(card.name)
                    .font(.system(size: 28, weight: .medium))
                Spacer()
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(
                                colors: [
                                    Color(hex: "864C13"),
                                    Color(hex: "544818")
                                ]
                            ),
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .stroke(.white.opacity(0.5))
                    .frame(height: 50)
                    .overlay {
                        Text(card.arrtibute)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(.white)
                    }
            }
            .padding(.horizontal, 8)
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
    }

    var starView: some View {
        Circle()
            .foregroundStyle(.red)
            .overlay {
                Image(systemName: "star.fill")
                    .resizable()
                    .foregroundStyle(.yellow)
                    .padding(4)
            }
            .frame(height: 36)
            .aspectRatio(1, contentMode: .fit)
    }

    var cardDescriptionView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("【\(card.species)族】")
                .font(.system(size: 20))
            Text(card.description)
                .font(.system(size: 16))
                .lineLimit(nil)
                .padding(.horizontal, 6)
            Spacer()
            Rectangle()
                .foregroundStyle(.black)
                .frame(height: 1)
            HStack {
                Spacer()
                Text("ATK/\(String(card.attackPoint))")
                    .font(.system(size: 16, weight: .medium))
                Text("DEF/\(String(card.defencePoint))")
                    .font(.system(size: 16, weight: .medium))
            }
        }
        .padding(4)
        .background(Color(hex: "B2ACA0"))
        .border(.black)
        .padding(.horizontal)
    }

    var paperTextureView: some View {
        ZStack {
            // ベースの紙（指定の色）
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "8F794E"))
                .shadow(
                    color: Color.black.opacity(0.4),
                    radius: 10,
                    x: 8,
                    y: 8
                )
            // ノイズ（紙のザラザラ感）を Canvas で描画
            Canvas { context, size in
                let dotCount = 3000
                for _ in 0..<dotCount {
                    let x = Double.random(in: 0...size.width)
                    let y = Double.random(in: 0...size.height)
                    let dotRect = CGRect(x: x, y: y, width: 4, height: 4)
                    context.fill(
                        Path(ellipseIn: dotRect),
                        with: .color(Color.white.opacity(Double.random(in: 0.2...0.4)))
                    )
                }
            }
            .blendMode(.softLight)
        }
    }
}

private extension CardView {
    func scale(for screenSize: CGSize) -> CGFloat {
        let widthScale = screenSize.width / CardView.cardSize.width
        let heightScale = screenSize.height / CardView.cardSize.height
        return min(widthScale, heightScale)
    }
}

#Preview {
    CardView(card: .sample2)
        .frame(width: 300)
}
