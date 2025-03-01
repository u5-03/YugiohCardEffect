//
//  CardModel.swift
//  YugiohCardEffect
//
//  Created by yugo.sugiyama on 2025/02/22.
//

import SwiftUI

public enum ImageType: Sendable {
    case image(image: Image, aspectRatio: CGFloat)
    case shape(shape: any Shape, aspectRatio: CGFloat)

    public var aspectRatio: CGFloat {
        switch self {
        case .image(_, let aspectRatio):
            return aspectRatio
        case .shape(_, let aspectRatio):
            return aspectRatio
        }
    }

    @ViewBuilder
    public var view: some View {
        switch self {
        case .image(let image, _):
            AnyView(image.resizable())
        case .shape(let shape, _):
            AnyView(
                shape
                    .stroke(lineWidth: 4)
                    .foregroundStyle(.black)
            )
        }
    }
}

public struct CardModel : Sendable {
    public let id: UUID
    public let name: String
    public let attribute: String
    public let starCount: Int
    public let imageType: ImageType
    public let imageBackgroundColor: Color
    public let species: String
    public let description: String
    public let attackPoint: Int
    public let defencePoint: Int
    public let isRare: Bool

    public init(name: String, attribute: String, starCount: Int, imageType: ImageType, imageBackgroundColor: Color, species: String, description: String, attackPoint: Int, defencePoint: Int, isRare: Bool = false) {
        self.id = UUID()
        self.name = name
        self.attribute = attribute
        self.starCount = starCount
        self.imageType = imageType
        self.imageBackgroundColor = imageBackgroundColor
        self.species = species
        self.description = description
        self.attackPoint = attackPoint
        self.defencePoint = defencePoint
        self.isRare = isRare
    }

    public static let sample: CardModel = .init(
        name: "Sugiy - あんこフォルム",
        attribute: "甘",
        starCount: 4,
        imageType: .shape(shape: SugiyShape(), aspectRatio: 974 / 648),
        imageBackgroundColor: Color(hex: "F2DBA0"),
        species: "甘党",
        description: "iOSエンジニアでありながら、Flutterのプロジェクトで働くエンジニア\n和食と和菓子と魚をこよなく愛している",
        attackPoint: 1200,
        defencePoint: 1000
    )

    public static let sample2: CardModel = .init(
        name: "デスマーチ明けのSugiy",
        attribute: "甘",
        starCount: 8,
        imageType: .image(image: .init(.sugiy), aspectRatio: 1),
        imageBackgroundColor: Color.white,
        species: "甘党",
        description: "「残業月80時間」の装備カードを装備した「Sugiy - あんこフォルム」をリリースした場合のみ特殊召喚できる。修羅場をくぐり抜けた無敵の状態。手札の「エナジードリンク」のカードを捨てることでこのカードを破壊・除外する魔法・罠・モンスターの効果を無効にして、破壊することができる。",
        attackPoint: 4500,
        defencePoint: 3000,
        isRare: true
    )
}

extension CardModel: Equatable {
    public static func == (lhs: CardModel, rhs: CardModel) -> Bool {
        lhs.id == rhs.id
    }
}
