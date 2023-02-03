//
//  Date.swift
//
//
//  Created by Andrej Jasso on 08/06/2021.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import Foundation
import GRCompatible

extension Date: GRCompatible {}

public extension GRActive where Base == Date {

    /// Adding return a new date with the added component
    /// 
    /// - Parameters:
    ///   - number: Number of component value to be added
    ///   - component: Component to add
    /// - Returns: New date with added component
    func adding(number: Int, of component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: number, to: base) ?? base
    }

}
