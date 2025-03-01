import SwiftUI

// MARK: - LineEffectView
/// LineEffectViewは、top, leading, trailingの各方向の線の設定配列を外部から受け取り、
/// それに基づいて線（RandomPathShape）を描画するViewです。
struct LineEffectView: View {
    let topLineConfigs: [LineConfig]
    let leadingLineConfigs: [LineConfig]
    let trailingLineConfigs: [LineConfig]
    let cardSize: CGSize

    @Binding var fromAnimationProgress: CGFloat
    @Binding var toAnimationProgress: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let dynamicLineWidth = min(proxy.size.width, proxy.size.height)  * 0.008
            // スタート枠の寸法：画面幅の1/3、アスペクト比8.6:5.9
            let frameWidth = cardSize.width
            let frameHeight = cardSize.height

            // スタート枠の左上座標（中央配置）
            let startFrameOrigin = CGPoint(
                x: (proxy.size.width - frameWidth) / 2,
                y: (proxy.size.height - frameHeight) / 2
            )

            // エンド枠の位置（SafeAreaの上端、左端、右端）
            let safeTop = proxy.safeAreaInsets.top + 5
            let safeLeft: CGFloat = 5
            let safeRight = proxy.size.width - 5

            // 各方向の線の本数は、設定配列の数に応じる
            let topCount = topLineConfigs.count
            let sideCount = leadingLineConfigs.count  // 左右は同じ本数

            // スタート枠の各辺を等間隔に分割する
            let topSegmentWidth = frameWidth / CGFloat(topCount)
            let sideSegmentHeight = frameHeight / CGFloat(sideCount)

            ZStack {
                // スタート枠を描画
//                Rectangle()
//                    .stroke(Color.gray, lineWidth: 1)
//                    .frame(width: frameWidth, height: frameHeight)
//                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
//                Button {
//                    fromAnimationProgress = -0.5
//                    toAnimationProgress = 0
//                    withAnimation {
//                        fromAnimationProgress = 1.0
//                        toAnimationProgress = 1.5
//                    }
//                } label: {
//                    Text("Animate")
//                }


                // エンド枠（上端）を描画
//                Rectangle()
//                    .stroke(Color.gray, lineWidth: 1)
//                    .frame(width: proxy.size.width, height: 2)
//                    .position(x: proxy.size.width / 2, y: safeTop)

                // 上方向の線
                ForEach(0..<topCount, id: \.self) { index in
                    let segmentStartX = startFrameOrigin.x + CGFloat(index) * topSegmentWidth
                    let segmentEndX = segmentStartX + topSegmentWidth
                    let startX = CGFloat.random(in: segmentStartX...segmentEndX)
                    let startPoint = CGPoint(x: startX, y: startFrameOrigin.y)

                    // 終点のx座標は、スタート枠のx軸内で、startXから±(10%-20% of frameWidth)の範囲
                    let lowerBound = max(startFrameOrigin.x, startX - frameWidth * 0.20)
                    let upperBound = min(startFrameOrigin.x + frameWidth, startX + frameWidth * 0.20)
                    let endX = CGFloat.random(in: lowerBound...upperBound)
                    let endPoint = CGPoint(x: endX, y: safeTop)

                    PathAnimatableShape(
                        fromAnimationProgress: fromAnimationProgress,
                        toAnimationProgress: toAnimationProgress,
                        shape: RandomPathShape(
                            startPoint: startPoint,
                            direction: .top,
                            config: topLineConfigs[index],
                            endPosition: endPoint,
                            lateralBound: frameWidth
                        )
                    )
                    .stroke(Color.red.opacity(0.6), lineWidth: dynamicLineWidth)
                }

                // 左方向の線
                ForEach(0..<sideCount, id: \.self) { index in
                    let segmentStartY = startFrameOrigin.y + CGFloat(index) * sideSegmentHeight
                    let segmentEndY = segmentStartY + sideSegmentHeight
                    let startY = CGFloat.random(in: segmentStartY...segmentEndY)
                    let startPoint = CGPoint(x: startFrameOrigin.x, y: startY)
                    let endPoint = CGPoint(x: safeLeft, y: startY)

                    PathAnimatableShape(
                        fromAnimationProgress: fromAnimationProgress,
                        toAnimationProgress: toAnimationProgress,
                        shape: RandomPathShape(
                            startPoint: startPoint,
                            direction: .leading,
                            config: leadingLineConfigs[index],
                            endPosition: endPoint,
                            lateralBound: frameWidth
                        )
                    )
                    .stroke(Color.red.opacity(0.6), lineWidth: dynamicLineWidth)
                }

                // 右方向の線
                ForEach(0..<sideCount, id: \.self) { index in
                    let segmentStartY = startFrameOrigin.y + CGFloat(index) * sideSegmentHeight
                    let segmentEndY = segmentStartY + sideSegmentHeight
                    let startY = CGFloat.random(in: segmentStartY...segmentEndY)
                    let startPoint = CGPoint(x: startFrameOrigin.x + frameWidth, y: startY)
                    let endPoint = CGPoint(x: safeRight, y: startY)

                    PathAnimatableShape(
                        fromAnimationProgress: fromAnimationProgress,
                        toAnimationProgress: toAnimationProgress,
                        shape: RandomPathShape(
                            startPoint: startPoint,
                            direction: .trailing,
                            config: trailingLineConfigs[index],
                            endPosition: endPoint,
                            lateralBound: frameWidth
                        )
                    )
                    .stroke(Color.red.opacity(0.6), lineWidth: dynamicLineWidth)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var fromAnimationProgress: CGFloat = -0.5
    @Previewable @State var toAnimationProgress: CGFloat = 0
    @Previewable @State var topLineConfigs: [LineConfig] = []
    @Previewable @State var leadingLineConfigs: [LineConfig] = []
    @Previewable @State var trailingLineConfigs: [LineConfig] = []

    func animation() {
        fromAnimationProgress = -0.5
        toAnimationProgress = 0
        withAnimation(.linear(duration: 1)) {
            fromAnimationProgress = 1
            toAnimationProgress = 1.5
        } completion: {
            topLineConfigs = LineConfig.randomConfigss(count: 10, isTop: true)
            leadingLineConfigs = LineConfig.randomConfigss(count: 12)
            trailingLineConfigs = LineConfig.randomConfigss(count: 12)

            animation()
        }
    }

    return LineEffectView(
        topLineConfigs: topLineConfigs,
        leadingLineConfigs: leadingLineConfigs,
        trailingLineConfigs: trailingLineConfigs,
        cardSize: CGSize(width: 150, height: 300),
        fromAnimationProgress: $fromAnimationProgress,
        toAnimationProgress: $toAnimationProgress
    )
    .frame(width: 600, height: 1000)
    .onAppear {
        animation()
    }
}
