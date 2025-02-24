import SwiftUI

/// 値を下限と上限の間に収める
func clamp(value: CGFloat, lower: CGFloat, upper: CGFloat) -> CGFloat {
    max(lower, min(value, upper))
}

// MARK: - PathStyle

/// 線のスタイルを表すenum
/// - straight: 直線
/// - leftCurved/rightCurved: 曲線の場合。
///   - firstTurnFraction: 始点から終点の直線上における最初の曲がり位置の割合（0〜1、0.1〜0.6にクランプ）
///   - secondTurnFraction: 2回目の曲がる位置の割合（0〜1、firstTurnFractionより大きく0.5〜0.9にクランプ）
///   - angle: 曲がる角度（常に正の値）
enum PathStyle: Equatable {
    case straight
    case leftCurved(firstTurnFraction: CGFloat, secondTurnFraction: CGFloat, angle: CGFloat)
    case rightCurved(firstTurnFraction: CGFloat, secondTurnFraction: CGFloat, angle: CGFloat)
}

// MARK: - LineConfig

/// 線の設定情報。外部から設定を与えることで、再構築時に一定の線を生成する。
struct LineConfig: Identifiable {
    let id = UUID()
    let pathStyle: PathStyle

    static func randomConfigss(count: Int, isTop: Bool = false) -> [LineConfig] {
        let firstTurnFractionRange: ClosedRange<CGFloat> = isTop ? 0.1...0.2 : 0.2...0.4
        let secondTurnFractionRange: ClosedRange<CGFloat> = isTop ? 0.3...0.4 : 0.5...0.8
        let pathStyles: [PathStyle] = [
            .straight,
            .leftCurved(firstTurnFraction: CGFloat.random(in: firstTurnFractionRange), secondTurnFraction: CGFloat.random(in: secondTurnFractionRange), angle: CGFloat.random(in: 25...35)),
            .rightCurved(firstTurnFraction: CGFloat.random(in: firstTurnFractionRange), secondTurnFraction: CGFloat.random(in: secondTurnFractionRange), angle: CGFloat.random(in: 25...35))
        ]

        return (0..<count).map { _ in
            let randomPathStyle = pathStyles.randomElement() ?? .straight
            return LineConfig(pathStyle: randomPathStyle)
        }
    }
}

// MARK: - Direction

enum Direction: CaseIterable {
    case top, leading, trailing
    static var random: Direction { allCases.randomElement()! }
}

// MARK: - RandomPathShape

/// 与えられた設定に基づいてPath（線）を生成するShape
/// 外部からLineConfigを渡すことで、各線のパラメーター（曲がる位置、角度など）を固定できる。
struct RandomPathShape: Shape {
    let startPoint: CGPoint      // スタート枠の境界上の始点
    let direction: Direction     // 線が伸びる方向 (.top, .leading, .trailing)
    let config: LineConfig       // 外部設定（PathStyleとパラメーター）
    let endPosition: CGPoint     // エンド枠の境界上の終点
    let lateralBound: CGFloat    // topの場合はスタート枠の横幅、left/rightの場合はスタート枠の高さ

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: startPoint)

        // 直線の場合は単に始点と終点を結ぶ（上方向はx固定）
        if config.pathStyle == .straight {
            if direction == .top {
                path.addLine(to: CGPoint(x: startPoint.x, y: endPosition.y))
            } else {
                path.addLine(to: endPosition)
            }
            return path
        }

        // 曲線の場合、設定からパラメーターを抽出する
        let firstTurnFraction: CGFloat
        let secondTurnFraction: CGFloat
        let specifiedAngle: CGFloat
        let isRightCurve: Bool
        switch config.pathStyle {
        case .leftCurved(let firstFrac, let secondFrac, let angle):
            firstTurnFraction = clamp(value: firstFrac, lower: 0.1, upper: 0.6)
            let minSecond = max(firstTurnFraction + 0.1, 0.5)
            secondTurnFraction = clamp(value: secondFrac, lower: minSecond, upper: 0.9)
            specifiedAngle = angle
            isRightCurve = false
        case .rightCurved(let firstFrac, let secondFrac, let angle):
            firstTurnFraction = clamp(value: firstFrac, lower: 0.1, upper: 0.6)
            let minSecond = max(firstTurnFraction + 0.1, 0.5)
            secondTurnFraction = clamp(value: secondFrac, lower: minSecond, upper: 0.9)
            specifiedAngle = angle
            isRightCurve = true
        default:
            path.addLine(to: endPosition)
            return path
        }

        // totalDistanceを各方向に応じて計算する
        let totalDistance: CGFloat
        switch direction {
        case .top:
            totalDistance = startPoint.y - endPosition.y
        case .leading:
            totalDistance = startPoint.x - endPosition.x
        case .trailing:
            totalDistance = endPosition.x - startPoint.x
        }

        // T1, T2は始点からの直線上の距離
        let T1 = firstTurnFraction * totalDistance
        var T2 = secondTurnFraction * totalDistance
        if T2 <= T1 { T2 = T1 + 0.1 * totalDistance }

        // 各方向ごとにswitchで処理する
        switch direction {
        case .top:
            // 上方向の場合：
            // 始点 (startX, startY)、終点 (endX, safeTop)
            // 1回目の曲がり点: (startX, startY - T1)
            // 2回目の曲がり点: (startX + horizontalOffset, startY - T2)
            // 最終点: (same x as 2回目, end.y)
            let startX = startPoint.x, startY = startPoint.y
            let point1 = CGPoint(x: startX, y: startY - T1)
            let horizontalOffset = (T2 - T1) * tan(specifiedAngle * CGFloat.pi / 180)
            let offset = isRightCurve ? horizontalOffset : -horizontalOffset
            let pointQ = CGPoint(x: startX + offset, y: startY - T2)
            let finalPoint = CGPoint(x: pointQ.x, y: endPosition.y)
            path.addLine(to: point1)
            path.addLine(to: pointQ)
            path.addLine(to: finalPoint)

        case .leading:
            // 左方向の場合：
            // 始点 (startX, startY)、終点 (safeLeft, startY)
            // 1回目の曲がり点: (startX - T1, startY)
            // 2回目の曲がり点: (startX - T2, startY + verticalOffset)
            // 最終点: (end.x, startY + verticalOffset) ※ここで2回目の曲がり点のy座標と同じにする
            let startX = startPoint.x, startY = startPoint.y
            let point1 = CGPoint(x: startX - T1, y: startY)
            let verticalOffset = (T2 - T1) * tan(specifiedAngle * CGFloat.pi / 180)
            let offsetY = (isRightCurve ? -verticalOffset : verticalOffset)  // 左側：leftCurved→verticalOffset, rightCurved→-verticalOffset
            let pointQ = CGPoint(x: startX - T2, y: startY + offsetY)
            let finalPoint = CGPoint(x: endPosition.x, y: startY + offsetY)
            path.addLine(to: point1)
            path.addLine(to: pointQ)
            path.addLine(to: finalPoint)

        case .trailing:
            // 右方向の場合：
            // 始点 (startX, startY)、終点 (safeRight, startY)
            // 1回目の曲がり点: (startX + T1, startY)
            // 2回目の曲がり点: (startX + T2, startY + verticalOffset)
            // 最終点: (end.x, startY + verticalOffset)
            let startX = startPoint.x, startY = startPoint.y
            let point1 = CGPoint(x: startX + T1, y: startY)
            let verticalOffset = (T2 - T1) * tan(specifiedAngle * CGFloat.pi / 180)
            let offsetY = (isRightCurve ? verticalOffset : -verticalOffset)
            let pointQ = CGPoint(x: startX + T2, y: startY + offsetY)
            let finalPoint = CGPoint(x: endPosition.x, y: startY + offsetY)
            path.addLine(to: point1)
            path.addLine(to: pointQ)
            path.addLine(to: finalPoint)
        }

        return path
    }
}
