//
//  String.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation
import GRCompatible

extension String: GRCompatible {}

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
