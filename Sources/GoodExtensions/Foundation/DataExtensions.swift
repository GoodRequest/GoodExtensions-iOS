//
//  Data.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation

public extension Data {
    
    /// Formats data as hex string. Format style: `0xA0B1C2`
    /// - Parameter hasPrefix: If resulting string should start with `0x` prefix.
    /// - Returns: Hex-formatted string
    func toString(hasPrefix: Bool = true) -> String {
        var result = hasPrefix ? "0x" : ""
        withUnsafeBytes { buffer in
            buffer.forEach { byte in result += String(format: "%02hhX", byte).uppercased() }
        }
        return result
    }

}
