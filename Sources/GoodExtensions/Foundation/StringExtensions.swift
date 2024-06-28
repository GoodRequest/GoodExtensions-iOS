//
//  String.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
extension String: GRCompatible {}

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public extension GRActive where Base == String {

    /// Returns `NSMutableAttributedString` from `String` without attributes
    var attributed: NSMutableAttributedString {
        NSMutableAttributedString(string: base, attributes: nil)
    }

    /// Creates a new string without whitespaces and new lines based on the old string
    var removeWhiteSpacesAndNewlines: String {
        return base.components(separatedBy: .whitespacesAndNewlines).joined()
    }

    /// Creates a new string without diacritics  based on the old string
    var removeDiacritics: String {
        return base.folding(options: .diacriticInsensitive, locale: .current)
    }

}

public extension String {
    
    /// Placeholder String for SwiftUI previews or redacted content
    /// - Parameter length: length of the placeholder string
    /// - Returns: String with length `length` composed of repeated "X" letters
    static func placeholder(length: Int) -> String {
        String(Array(repeating: "X", count: length))
    }

    @available(*, deprecated, renamed: "normalize()")
    func searchify() -> Self {
        normalize()
    }

    /// Normalizes/searchifies the string for easier comparision with other strings.
    /// - Returns: String with trimmed whitespaces, newlines, removed diacritics and lowercased.
    func normalize() -> Self {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: nil)
    }

}
