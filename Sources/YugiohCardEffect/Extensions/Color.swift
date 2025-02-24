//
//  Color.swift
//  YugiohCardEffect
//
//  Created by yugo.sugiyama on 2025/02/22.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)

        let a, r, g, b: Double
        switch hexSanitized.count {
        case 6: // #RRGGBB
            (a, r, g, b) = (1,
                            Double((int >> 16) & 0xFF) / 255,
                            Double((int >> 8) & 0xFF) / 255,
                            Double(int & 0xFF) / 255)
        case 8: // #RRGGBBAA
            (a, r, g, b) = (Double((int >> 24) & 0xFF) / 255,
                            Double((int >> 16) & 0xFF) / 255,
                            Double((int >> 8) & 0xFF) / 255,
                            Double(int & 0xFF) / 255)
        default:
            (a, r, g, b) = (1, 0, 0, 0) // デフォルト: 黒
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }

    func lighter(by percentage: Double) -> Color {
        return adjustBrightness(by: abs(percentage))
    }

    private func adjustBrightness(by percentage: Double) -> Color {
        guard let components = UIColor(self).cgColor.components else { return self }
        let red = min(components[0] + percentage, 1.0)
        let green = min(components[1] + percentage, 1.0)
        let blue = min(components[2] + percentage, 1.0)
        return Color(red: red, green: green, blue: blue)
    }
}
