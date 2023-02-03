//
//  OptionSetExtension.swift
//  GoodExtensions
//
//  Created by Filip Šašala on 14/02/2022.
//  Copyright © 2022 GoodRequest. All rights reserved.
//

/// Add respective binary-equivalent operations to bitset type
public extension OptionSet {

    /// Performs union of two bitsets, represented by bitwise OR
    ///
    /// - Parameters:
    ///   - lhs: Left side operand
    ///   - rhs: Right side operand
    /// - Returns: Union of bitsets in parameters
    static func | (lhs: Self, rhs: Self) -> Self {
        lhs.union(rhs)
    }

    /// Performs symmetric difference between two bitsets, represented by bitwise AND
    ///
    /// - Parameters:
    ///   - lhs: Left side operand
    ///   - rhs: Right side operand
    /// - Returns: Intersection between bitsets in parameters
    static func & (lhs: Self, rhs: Self) -> Self {
        lhs.intersection(rhs)
    }
    
    /// Performs symmetric difference between two bitsets, represented by bitwise XOR
    ///
    /// - Parameters:
    ///   - lhs: Left side operand
    ///   - rhs: Right side operand
    /// - Returns: Symmetric difference between bitsets in parameters
    static func ^ (lhs: Self, rhs: Self) -> Self {
        lhs.symmetricDifference(rhs)
    }

}
