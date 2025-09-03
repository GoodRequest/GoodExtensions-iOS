//
//  String.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation

public extension String {
    
    /// Placeholder String for SwiftUI previews or redacted content
    /// - Parameter length: length of the placeholder string
    /// - Returns: String with length `length` composed of repeated "X" letters
    static func placeholder(length: Int) -> String {
        String(Array(repeating: "X", count: length))
    }

    /// Normalizes/searchifies the string for easier comparision with other strings.
    /// - Returns: String with trimmed whitespaces, newlines, removed diacritics and lowercased.
    func normalize() -> Self {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: nil)
    }

}
