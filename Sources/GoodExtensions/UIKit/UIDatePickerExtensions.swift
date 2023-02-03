//
//  UIDatePicker.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import UIKit
import GRCompatible

public extension GRActive where Base: UIDatePicker {

    /// Property that wraps `base.date` property and triggers a `.valueChanged` event when set.
    var dateBinding: Date {
        get {
            return base.date
        }
        set {
            base.date = newValue
            base.sendActions(for: .valueChanged)
        }
    }

}
