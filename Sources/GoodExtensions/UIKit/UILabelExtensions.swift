//
//  UILabel.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import UIKit
import GRCompatible

public extension GRActive where Base: UILabel {

    /// Returns true if intrisic width is wider than bounds, otherwise false
    var isTruncated: Bool { base.intrinsicContentSize.width > base.bounds.width }

}
