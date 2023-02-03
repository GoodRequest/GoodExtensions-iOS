//
//  OptionalExtensions.swift
//  
//
//  Created by Andrej Jasso on 24/01/2022.
//

import Foundation

public extension Optional {

    /// If the optional has a value, the property returns `true`, otherwise it returns `false`.
    var isNotNil: Bool { self != nil }

    /// If the optional has no value, the property returns `true`, otherwise it returns `false`.
    var isNil: Bool { self == nil }

}
