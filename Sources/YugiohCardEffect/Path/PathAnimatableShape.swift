//
//  PathAnimatableShape.swift
//  YugiohCardEffect
//
//  Created by yugo.sugiyama on 2025/02/15.
//

import SwiftUI

public struct PathAnimatableShape {
    public var fromAnimationProgress: CGFloat = 0
    public var toAnimationProgress: CGFloat = 0
    public let shape: any Shape

    public init(fromAnimationProgress: CGFloat, toAnimationProgress: CGFloat, shape: any Shape) {
        self.fromAnimationProgress = fromAnimationProgress
        self.toAnimationProgress = toAnimationProgress
        self.shape = shape
    }
}

extension PathAnimatableShape: Shape {
    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            return AnimatablePair(fromAnimationProgress, toAnimationProgress)
        }
        set {
            fromAnimationProgress = newValue.first
            toAnimationProgress = newValue.second
        }
    }

    public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect)
            .trimmedPath(
                from: fromAnimationProgress,
                to: toAnimationProgress
            )
    }
}
