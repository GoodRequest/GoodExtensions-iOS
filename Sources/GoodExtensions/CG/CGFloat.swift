//
//  CGFloatExtensions.swift
//  
//
//  Created by Andrej Jasso on 24/01/2022.
//

import CoreGraphics
import GRCompatible

public extension CGFloat {
    
    // MARK: - Alpha stages

    /// CGFloat translucent representation
    static var translucent: CGFloat { GRActive.discreetZero }

    /// CGFloat solid representation
    static var solid: CGFloat { GRActive.discreetOne }
    
}

extension CGFloat: GRCompatible {}

public extension GRActive where Base == CGFloat {

    /// CGFloat `0.0` representation
    static var discreetZero: CGFloat { .zero }

    /// CGFloat `1.0` representation
    static var discreetOne: CGFloat { 1.0 }

    // MARK: - Clamping

    /// Clamped value within discreet bounds
    var discreetClamped: CGFloat {
        return clamped(lowerBound: GRActive.discreetZero, upperBound: GRActive.discreetOne)
    }

    /// Clamps the value of CGFloat to given lowerBound and upperBound.
    ///
    /// - Parameters:
    ///   - lowerBound: The lower bound to check
    ///   - upperBound: The upper bound to check
    /// - Returns: Returns 
    func clamped(lowerBound: CGFloat, upperBound: CGFloat) -> CGFloat {
        if base <= lowerBound {
            return lowerBound
        } else if base >= upperBound {
            return upperBound
        }

        return base
    }

}
