//
//  YugiohCardEffectController.swift
//  YugiohCardEffect
//
//  Created by yugo.sugiyama on 2025/02/27.
//

import SwiftUI
import Observation

@Observable @MainActor
public class YugiohCardEffectController {
    var fromAnimationProgress: CGFloat = -1
    var toAnimationProgress: CGFloat = -1
    private(set) var cardAngle: Angle = .degrees(-90)
    private(set) var topLineConfigs: [LineConfig] = []
    private(set) var leadingLineConfigs: [LineConfig] = []
    private(set) var trailingLineConfigs: [LineConfig] = []
    var selectedCardModel: CardModel? {
        if selectedIndex + 1 > cardModels.count || selectedIndex < 0 {
            return nil
        }
        return cardModels[selectedIndex]
    }
    private var selectedIndex = -1

    let cardModels: [CardModel]

    public init(cardModels: [CardModel]) {
        self.cardModels = cardModels
    }

    public func startEffectAnimation() async {
        reset()
        try? await Task.sleep(for: .milliseconds(100))

        withAnimation(.linear(duration: 0.5)) {
            cardAngle = .degrees(0)
        } completion: { [weak self] in
            guard let self else { return }
            withAnimation(.linear(duration: 0.3)) {
                self.fromAnimationProgress = 1
                self.toAnimationProgress = 2
            }
        }
    }

    private func reset() {
        topLineConfigs = LineConfig.randomConfigss(count: 7, isTop: true)
        leadingLineConfigs = LineConfig.randomConfigss(count: 10)
        trailingLineConfigs = LineConfig.randomConfigss(count: 10)
        cardAngle = .degrees(-90)
        fromAnimationProgress = -1
        toAnimationProgress = 0

        if self.selectedIndex + 1 >= self.cardModels.count || self.selectedIndex < 0 {
            self.selectedIndex = 0
        } else {
            self.selectedIndex += 1
        }
    }
}
