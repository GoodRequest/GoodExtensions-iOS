//
//  CGAffineTransform.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import UIKit

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
extension CGAffineTransform: GRCompatible {}

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public extension GRActive where Base == CGAffineTransform {

    /// Create a transform with scale, translation and anchor in place with the create function
    ///
    /// - Parameters:
    ///   - scale: CGFloat  scale multipier
    ///   - translation: CGPoint translation constant
    ///   - anchorPoint: Default pivot point important for rotation default value is X:0.5 Y:0.5.
    ///   - view: The view whose transform will be baseline.
    /// - Returns: CGAfficeTransform in a modified state base on input parameters
    static func create(
    	scale: CGFloat, translation: CGPoint, anchorPoint: CGPoint = .zero, for view: UIView
    ) -> CGAffineTransform {
        view.layer.anchorPoint = anchorPoint
        let scale = scale != 0 ? scale : CGFloat.leastNonzeroMagnitude
        let translationX = 1 / scale * (anchorPoint.x - 0.5) * (view.bounds.width - translation.x * 2)
        let translationY = 1 / scale * (anchorPoint.y - 0.5) * (view.bounds.height - translation.y * 2)
        return CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: translationX, y: translationY)
    }

}
