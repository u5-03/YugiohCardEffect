//
//  ShineColor.swift
//  YugiohCardEffect
//
//  Created by yugo.sugiyama on 2025/02/27.
//

import SwiftUI

enum ShineColor {
    case gold
    case silver
    case bronze
    case none

    var colors: [Color] {
        switch self {
        case .gold: return [
            Color(hex: 0xDBB400),
            Color(hex: 0xEFAF00),
            Color(hex: 0xF5D100),
            Color(hex: 0xE0CA82),
            Color(hex: 0xD1AE15),
            Color(hex: 0xDBB400),
        ]
        case .silver: return [
            Color(hex: 0x70706F),
            Color(hex: 0x7D7D7A),
            Color(hex: 0xB3B6B5),
            Color(hex: 0x8E8D8D),
            Color(hex: 0xB3B6B5),
            Color(hex: 0xA1A2A3),
        ]
        case .bronze: return [
            Color(hex: 0x804A00),
            Color(hex: 0x9C7A3C),
            Color(hex: 0xB08D57),
            Color(hex: 0x895E1A),
            Color(hex: 0x804A00),
            Color(hex: 0xB08D57),
        ]
        case .none:
            return [.black]
        }
    }
    var linearGradient: LinearGradient
    {
        return LinearGradient(
            gradient: Gradient(colors: self.colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
extension View {
    func shine(_ color: ShineColor) -> some View {
        ZStack {
            self.opacity(0)
            color.linearGradient.mask(self)
        }.fixedSize()
    }
}
fileprivate extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init( .sRGB,
                   red: Double((hex >> 16) & 0xff) / 255,
                   green: Double((hex >> 08) & 0xff) / 255,
                   blue: Double((hex >> 00) & 0xff) / 255,
                   opacity: alpha )
    }
}
