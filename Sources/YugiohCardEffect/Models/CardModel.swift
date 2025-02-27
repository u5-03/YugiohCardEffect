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
            )
        }
    }
}

public struct CardModel : Sendable{
    public let id: UUID
    public let name: String
    public let arrtibute: String
    public let starCount: Int
    public let imageType: ImageType
    public let imageBackgroundColor: Color
    public let species: String
    public let description: String
    public let attackPoint: Int
    public let defencePoint: Int

    public init(name: String, arrtibute: String, starCount: Int, imageType: ImageType, imageBackgroundColor: Color, species: String, description: String, attackPoint: Int, defencePoint: Int) {
        self.id = UUID()
        self.name = name
        self.arrtibute = arrtibute
        self.starCount = starCount
        self.imageType = imageType
        self.imageBackgroundColor = imageBackgroundColor
        self.species = species
        self.description = description
        self.attackPoint = attackPoint
        self.defencePoint = defencePoint
    }

    public static let sample: CardModel = .init(
        name: "Sugiy - あんこフォルム",
        arrtibute: "甘",
        starCount: 5,
        imageType: .shape(shape: SugiyShape(), aspectRatio: 974 / 648),
        imageBackgroundColor: Color(hex: "F2DBA0"),
        species: "甘党",
        description: "iOSエンジニアでありながら、Flutterのプロジェクトで働くエンジニア\n和食と和菓子と魚をこよなく愛している",
        attackPoint: 1200,
        defencePoint: 1000
    )

    public static let sample2: CardModel = .init(
        name: "Sugiy - あんこフォルム",
        arrtibute: "甘",
        starCount: 5,
        imageType: .image(image: .init(.sugiy), aspectRatio: 1),
        imageBackgroundColor: Color.white,
        species: "甘党",
        description: "iOSエンジニアでありながら、Flutterのプロジェクトで働くエンジニア\n和食と和菓子と魚をこよなく愛している",
        attackPoint: 1200,
        defencePoint: 1000
    )
}
